# Based from Phoenix reference image https://hexdocs.pm/phoenix/releases.html#containers

ARG ELIXIR_VERSION=1.12.3
ARG MIX_ENV="prod"

FROM elixir:${ELIXIR_VERSION}-alpine as build

# install build dependencies
RUN apk add --no-cache --update git build-base curl

RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies to ensure any
# relevant config change will trigger the dependencies to be re-compiled.
COPY config/config.exs config/$MIX_ENV.exs config/
RUN mix deps.compile

# Copy files particular from this Application. Usually is assets or such
COPY priv priv

# compile and build the release
COPY lib lib
RUN mix compile

# changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

RUN mix release


# start a new build stage so that the final image will only contain the compiled release and other runtime necessities
# Base image seen here https://github.com/erlang/docker-erlang-otp/blob/02ca6cebdf5f3765856f90f255f050d0dabeda74/24/alpine/Dockerfile
FROM alpine:3.14 as app
RUN apk add --no-cache libstdc++ openssl ncurses-libs

RUN mkdir /app
WORKDIR /app

USER 1000

# set build ENV
ARG MIX_ENV
ENV MIX_ENV="${MIX_ENV}"

# copy release from previous stage
COPY --from=build --chown=1000:1000 /app/_build/"${MIX_ENV}"/rel/cashier ./

ENTRYPOINT ["bin/cashier"]

# Usage:
#  * build: sudo docker image build -t my_app:latest .
#  * shell: sudo docker container run --rm -it --entrypoint "" my_app:latest sh
#  * run:   sudo docker container run --rm -it --name my_app my_app:latest
#  * exec:  sudo docker container exec -it my_app sh
#  * logs:  sudo docker container logs --follow --tail 100 my_app
CMD ["start"]


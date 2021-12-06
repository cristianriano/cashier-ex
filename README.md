# Cashier System

Simple cashier function that adds products to a cart and displays the total price.

The following products are registered:

| Product Code | Name | Price |
|--------------|------|-------|
| GR1 | Green Tea | £3.11 |
| SR1 | Strawberries | £5.00 |
| CF1 | Coffee | £11.23 |

**Special Rules**

- Buy one get one free
- Buy > N products, pay X price per product
- Buy > N products, pay X% of the original price

## Products and Discount Rules

The project **doesn't connect to a database**, it reads both the products and rules from a YAML file.\
The default location of the file is `priv/assets/products.yml` and `priv/assets/rules.yml`, this can be changed in the Configuration.

Currently there are only 3 types of configurable discount rules:
- FreeRule (buy X get 1 free)
- ReducedPriceRule (buy more than X pay a different price)
- FractionPriceRule (buy more than X, pay a percentage of the original price)

## Setup

- Elixir 1.12.3
- Erlang OTP 24
- Run tests with `mix tests`
- Run the formatter with `mix format`
- Run Credo `mix credo --strict`

*Note:* There is a Github Action configured running all the above on every PR or push to master

## Release

To create a release simply run\
`mix release`

Additonally a Docker image is available for production
```
docker build . -t cashier-ex:latest
docker run -d --rm -it --name cashier-ex cashier-ex:latest
```

## Improvements

- Add an TCP interface
- Spawn more than 1 repo and use consistent hashing to route calls
- Macro for repo

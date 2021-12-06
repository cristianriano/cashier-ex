defmodule Cashier.Repo do
  @moduledoc """
    Manage N supervised repo processes
  """

  def start_link(config) do
    module = Keyword.fetch!(config, :module)
    name = Keyword.get(config, :name, :"#{module}.Supervisor")
    replicas = Keyword.get(config, :replicas, 2)
    init_args = Keyword.get(config, :init_args, [])

    children = for n <- 1..replicas, do: child_spec_for(module, n, init_args)

    Supervisor.start_link(children, strategy: :one_for_one, name: name)
  end

  def execute(module, n, function, args) do
    args = [gen_name(module, n) | args]
    apply(module, function, args)
  end

  def child_spec(args) do
    module = Keyword.fetch!(args, :module)
    name = Keyword.get(args, :name, :"#{module}.Supervisor")

    %{
      id: name,
      start: {__MODULE__, :start_link, [args]}
    }
  end

  defp child_spec_for(module, n, init_args) do
    name = gen_name(module, n)
    start_args = Keyword.merge(init_args, name: name)

    %{
      id: name,
      start: {module, :start_link, [start_args]},
      restart: :permanent,
      shutdown: 5_000
    }
  end

  defp gen_name(module, n) do
    if n == 1, do: module, else: :"#{module}#{n}"
  end
end
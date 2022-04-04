defmodule Cashier.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Cashier.Repo, module: Cashier.ProductRepo},
      {Cashier.Repo, module: Cashier.RuleRepo}
    ]

    opts = [strategy: :one_for_one, name: Cashier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

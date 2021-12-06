defmodule Cashier.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Cashier.ProductRepo,
      Cashier.RuleRepo
    ]

    opts = [strategy: :one_for_one, name: Cashier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

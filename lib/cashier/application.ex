defmodule Cashier.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        ProductRepo,
        file_path: Application.fetch_env!(:cashier, :products_file)
      }
    ]

    opts = [strategy: :one_for_one, name: Cashier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

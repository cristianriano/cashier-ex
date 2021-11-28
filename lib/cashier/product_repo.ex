defmodule ProductRepo do
  @moduledoc """
    This module is a GenServer which contains all the products loaded during start up
  """
  use GenServer

  require Logger

  alias Cashier.Product

  @spec find_product_by_code(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  def find_product_by_code(code) do
    GenServer.call(__MODULE__, {:find_by_code, code})
  end

  def handle_call({:find_by_code, code}, _from, %{products: products} = state) do
    {:reply, find_product_by_code(code, products), state}
  end

  def start_link(args) do
    file_path = Keyword.fetch!(args, :file_path)

    GenServer.start_link(
      __MODULE__,
      %{file_path: file_path, products: []},
      name: __MODULE__
    )
  end

  def init(%{file_path: file_path} = state) do
    case load_products(file_path) do
      {:ok, products} -> {:ok, %{state | products: products}}
      {:error, reason} -> {:stop, reason}
      _ -> {:stop, :error}
    end
  end

  defp find_product_by_code(query, products) do
    case Enum.find(products, fn %Product{code: code} -> query == code end) do
      product when is_struct(product) -> {:ok, product}
      nil -> {:error, :not_found}
    end
  end

  defp load_products(path) do
    parse_path(path)
    |> YamlElixir.read_from_file()
    |> process_file()
  end

  defp parse_path(path) do
    File.cwd!()
    |> Path.join(path)
  end

  defp process_file({:ok, %{"products" => products}}) do
    parsed_products =
      products
      |> Enum.map(&Product.new/1)
      |> Enum.reject(&is_nil/1)

    {:ok, parsed_products}
  end

  defp process_file({:error, error}) do
    Logger.error(error.message)
    {:error, error.message}
  end
end

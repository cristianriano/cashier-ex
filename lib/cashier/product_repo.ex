defmodule Cashier.ProductRepo do
  @moduledoc """
    This module is a GenServer which contains all the products loaded during start up
  """
  use GenServer

  require Logger

  alias Cashier.Product
  alias Cashier.Utils

  @spec find_product_by_code(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  def find_product_by_code(code) do
    GenServer.call(__MODULE__, {:find_by_code, code})
  end

  @spec find_product_by_code!(String.t()) :: Product.t()
  def find_product_by_code!(code) do
    {:ok, product} = find_product_by_code(code)
    product
  end

  @spec find_all() :: {:ok, list(Product.t())}
  def find_all do
    GenServer.call(__MODULE__, :find_all)
  end

  def handle_call({:find_by_code, code}, _from, %{products: products} = state) do
    {:reply, find_product_by_code(code, products), state}
  end

  def handle_call(:find_all, _from, %{products: products} = state) do
    {:reply, products, state}
  end

  def start_link(args) do
    file_path = Keyword.fetch!(args, :file_path)
    name = Keyword.get(args, :name, __MODULE__)

    GenServer.start_link(
      __MODULE__,
      %{file_path: file_path, products: []},
      name: name
    )
  end

  def init(%{file_path: file_path} = state) do
    case load_products(file_path) do
      {:ok, products} -> {:ok, %{state | products: products}}
      {:error, reason} -> {:stop, reason}
    end
  end

  @spec find_product_by_code(Product.code(), list(Product.t())) ::
          {:ok, Product.t()} | {:error, :not_found}
  defp find_product_by_code(query, products) do
    case Enum.find(products, fn %Product{code: code} -> query == code end) do
      product when is_struct(product) -> {:ok, product}
      nil -> {:error, :not_found}
    end
  end

  @spec load_products(String.t()) :: {:ok, list(Product.t())} | {:error, String.t()}
  defp load_products(path) do
    path
    |> Utils.parse_path()
    |> YamlElixir.read_from_file()
    |> process_file()
  end

  @spec process_file({:ok, map()} | {:error, any()}) ::
          {:ok, list(Product.t())} | {:error, String.t()}
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

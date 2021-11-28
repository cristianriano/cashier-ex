defmodule Cashier do
  @moduledoc """
  Interface with the Cashier app
  """

  alias Cashier.Product
  alias Cashier.ProductRepo

  @spec find_product_by_code(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  defdelegate find_product_by_code(code), to: ProductRepo

  @spec calculate_total_price(String.t()) :: float()
  def calculate_total_price(codes) do
    0.0
  end
end

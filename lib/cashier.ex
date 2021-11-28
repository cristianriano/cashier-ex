defmodule Cashier do
  @moduledoc """
  Interface with the Cashier app
  """

  alias Cashier.Product

  @spec find_product_by_code(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  defdelegate find_product_by_code(code), to: ProductRepo
end

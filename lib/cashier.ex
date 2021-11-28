defmodule Cashier do
  @moduledoc """
  Interface with the Cashier app
  """

  alias Cashier.Product

  @spec get_product_info(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  def get_product_info(code) do
    {:error, :not_found}
  end
end

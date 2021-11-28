defmodule Cashier.Basket do
  @moduledoc """
    Represents a purchase composed by a list of products and their final price
  """

  @type t() :: %__MODULE__{
          products: list(Product.t()),
          quantities_by_code: map(),
          total_price: float()
        }

  @enforce_keys [:products]
  defstruct products: [],
            quantities_by_code: %{},
            total_price: 0.0

  alias Cashier.Product

  @spec new(list(Product.t())) :: t()
  def new(products) do
    %__MODULE__{products: products}
  end
end

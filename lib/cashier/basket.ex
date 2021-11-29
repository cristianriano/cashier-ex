defmodule Cashier.Basket do
  @moduledoc """
    Represents a purchase composed by a list of products and their final price
  """

  alias Cashier.Product

  @type t() :: %__MODULE__{
          products: nonempty_list(Product.t()),
          quantities_by_code: map(),
          total_price: float()
        }

  @enforce_keys [:products]
  defstruct products: [],
            quantities_by_code: %{},
            total_price: 0.0

  @spec new(nonempty_list(Product.t())) :: t()
  def new(products) do
    %__MODULE__{
      products: products,
      quantities_by_code: count_by_code(products),
      total_price: calculate_initial_price(products)
    }
  end

  @spec reduce_total_price(t(), float()) :: t()
  def reduce_total_price(basket, deduction) do
    new_price = case basket.total_price - deduction do
      diff when diff >= 0 -> diff
      _ -> 0
    end

    %{basket | total_price: new_price}
  end

  defp count_by_code(products) do
    products
    |> Enum.map(&(&1.code))
    |> Enum.frequencies()
  end

  defp calculate_initial_price(products) when is_list(products) do
    products
    |> Enum.reduce(0.0, fn product, acc_price -> product.price + acc_price end)
  end
end

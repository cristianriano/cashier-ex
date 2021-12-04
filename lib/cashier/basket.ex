defmodule Cashier.Basket do
  @moduledoc """
    Represents a purchase composed by a list of products and their final price
  """

  alias Cashier.Product

  @type t() :: %__MODULE__{
          products_by_code: %{Product.code() => Product.t()},
          quantities_by_code: %{Product.code() => non_neg_integer()},
          total_price: float()
        }

  defstruct products_by_code: %{},
            quantities_by_code: %{},
            total_price: 0.0

  @spec new(nonempty_list(Product.t())) :: t()
  def new(products) when is_list(products) do
    %__MODULE__{
      products_by_code: group_products_by_code(products),
      quantities_by_code: count_by_code(products),
      total_price: calculate_initial_price(products)
    }
  end

  @spec reduce_total_price(t(), float()) :: t()
  def reduce_total_price(basket, deduction) when deduction > 0 do
    new_price =
      case basket.total_price - deduction do
        diff when diff >= 0 -> diff
        _ -> 0
      end

    %{basket | total_price: new_price}
  end

  def reduce_total_price(basket, _), do: basket

  @spec group_products_by_code(nonempty_list(Product.t())) :: %{Product.code() => Product.t()}
  defp group_products_by_code(products) do
    Enum.reduce(products, %{}, fn %Product{code: code} = p, acc -> Map.put(acc, code, p) end)
  end

  @spec count_by_code(nonempty_list(Product.t())) :: %{Product.code() => pos_integer()}
  defp count_by_code(products) do
    products
    |> Enum.map(& &1.code)
    |> Enum.frequencies()
  end

  @spec calculate_initial_price(nonempty_list(Product.t())) :: float()
  defp calculate_initial_price(products) do
    products
    |> Enum.reduce(0.0, fn product, acc_price -> product.price + acc_price end)
  end
end

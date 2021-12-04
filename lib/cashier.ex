defmodule Cashier do
  @moduledoc """
  Interface with the Cashier app
  """

  alias Cashier.Basket
  alias Cashier.Product
  alias Cashier.ProductRepo
  alias Cashier.Rule
  alias Cashier.RuleRepo

  @spec find_product_by_code(String.t()) :: {:ok, Product.t()} | {:error, :not_found}
  defdelegate find_product_by_code(code), to: ProductRepo

  @spec calculate_total_price(String.t()) :: float()
  def calculate_total_price(codes) do
    basket =
      codes
      |> parse_codes()
      |> Basket.new()

    new_basket =
      RuleRepo.find_all()
      |> Enum.filter(&Map.has_key?(basket.products_by_code, &1.target))
      |> Enum.reduce(basket, fn rule, basket ->
        Rule.apply_discount(rule, basket)
      end)

    new_basket.total_price
  end

  @spec parse_codes(String.t()) :: list(Product.t())
  defp parse_codes(codes) do
    codes
    |> String.split(",")
    |> Enum.map(&ProductRepo.find_product_by_code!/1)
    |> Enum.reject(&is_nil/1)
  end
end

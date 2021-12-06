defmodule Cashier do
  @moduledoc """
  Interface with the Cashier app
  """

  alias Cashier.Basket
  alias Cashier.Product
  alias Cashier.Repo
  alias Cashier.Rule

  @spec find_product_by_code(String.t()) :: Product.t() | nil
  def find_product_by_code(code) do
    Repo.execute(Cashier.ProductRepo, 1, :find_product_by_code!, [code])
  rescue
    _ -> nil
  end

  @spec find_all_rules() :: list(Rule.t())
  def find_all_rules do
    Repo.execute(Cashier.RuleRepo, 2, :find_all, [])
  end

  @spec calculate_total_price(String.t()) :: float()
  def calculate_total_price(codes) do
    basket =
      codes
      |> parse_codes()
      |> Basket.new()

    new_basket =
      find_all_rules()
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
    |> Enum.map(&find_product_by_code/1)
    |> Enum.reject(&is_nil/1)
  end
end

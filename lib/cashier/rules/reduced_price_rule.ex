defmodule Cashier.Rules.ReducedPriceRule do
  @moduledoc """
    This rule represents getting a new reduced price when buying in bulk
  """

  alias Cashier.Basket
  alias Cashier.Rule

  @behaviour Rule

  def init(%{target: target, min: min, new_price: new_price} = args) when is_binary(target) do
    %Rule{
      target: target,
      process: fn %Basket{products_by_code: products, quantities_by_code: quantities} = basket ->
        case quantities[target] do
          q when q >= min ->
            discount = (products[target].price - new_price) * q
            Basket.reduce_total_price(basket, discount)

          _ ->
            basket
        end
      end
    }
  end
end

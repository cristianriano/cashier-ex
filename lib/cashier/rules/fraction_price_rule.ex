defmodule Cashier.Rules.FractionPriceRule do
  @moduledoc """
    This rule represents getting a fraction of the original price when buying in bulk
  """

  alias Cashier.Basket
  alias Cashier.Rule

  @behaviour Rule

  def init(%{target: target, min: min, fraction: fraction}) when is_binary(target) do
    %Rule{
      target: target,
      process: fn %Basket{products_by_code: products, quantities_by_code: quantities} = basket ->
        case quantities[target] do
          q when q >= min and fraction < 1.0 ->
            discount = products[target].price * (1 - fraction) * q
            Basket.reduce_total_price(basket, discount)

          _ ->
            basket
        end
      end
    }
  end
end

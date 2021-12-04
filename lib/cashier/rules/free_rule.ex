defmodule Cashier.Rules.FreeRule do
  @moduledoc """
    This rule represents the behaviour of buying X and getting one product free
  """

  alias Cashier.Basket
  alias Cashier.Rule

  @behaviour Rule

  def init(%{target: target, min: min}) when is_binary(target) do
    %Rule{
      target: target,
      process: fn %Basket{products_by_code: products, quantities_by_code: quantities} = basket ->
        case quantities[target] do
          q when q >= min ->
            discount = div(q, min + 1) * products[target].price
            Basket.reduce_total_price(basket, discount)

          _ ->
            basket
        end
      end
    }
  end
end

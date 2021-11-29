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
      process: fn basket -> basket end
    }
  end
end

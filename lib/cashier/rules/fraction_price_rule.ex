defmodule Cashier.Rules.FractionPriceRule do
  @moduledoc """
    This rule represents getting a fraction of the original price when buying in bulk
  """
  alias Cashier.Rule

  @behaviour Rule

  def init(%{target: target, min: min, fraction: fraction} = args) when is_binary(target) do
    %Rule{
      target: target,
      process: fn basket -> basket end
    }
  end
end

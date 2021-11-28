defmodule Cashier.Rules.FreeRule do
  @moduledoc """
    This rule represents the behaviour of buying X and getting one product free
  """
  alias Cashier.Rule

  @behaviour Rule

  def init(%{target: target, min: min} = args) when is_binary(target) do
    %Rule{
      target: target,
      process: fn basket -> basket end
    }
  end
end

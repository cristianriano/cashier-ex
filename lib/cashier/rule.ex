defmodule Cashier.Rule do
  @moduledoc """
    Interface for a discount rule
  """

  alias Cashier.Basket
  alias Cashier.Product
  alias Cashier.Rules.FractionPriceRule
  alias Cashier.Rules.FreeRule
  alias Cashier.Rules.ReducedPriceRule
  alias Cashier.Utils

  @type target() :: Product.code()
  @type rule_options() :: :min | :new_price | :target | :fraction
  @type rule_process_fun() :: (Basket.t() -> Basket.t())
  @type t() :: %__MODULE__{
          target: target(),
          process: fun()
        }

  @enforce_keys [:target, :process]
  defstruct target: nil,
            process: nil

  @callback init(args :: %{rule_options() => any()}) :: t()

  @spec new(map()) :: t()
  def new(args) when is_map(args) do
    new_args =
      args
      |> Utils.transform_keys()
      |> Map.take([:min, :target, :new_price, :fraction, :type])

    case new_args[:type] do
      "free" -> FreeRule.init(new_args)
      "reduced_price" -> ReducedPriceRule.init(new_args)
      "fraction_price" -> FractionPriceRule.init(new_args)
      _ -> nil
    end
  end

  @spec apply_discount(rule :: t(), basket :: Basket.t()) :: Basket.t()
  def apply_discount(rule, basket) do
    apply(rule.process, [basket])
  end
end

defmodule RuleTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Cashier.Basket
  alias Cashier.Product
  alias Cashier.Rule

  setup context do
    target = "GR1"

    rule =
      Rule.new(%{
        min: context[:min] || 1,
        target: target,
        new_price: 2.0,
        fraction: 0.5,
        type: context[:type]
      })

    basket =
      Basket.new([
        Product.new(%{code: target, price: "4.0"}),
        Product.new(%{code: target, price: "4.0"}),
        Product.new(%{code: target, price: "4.0"})
      ])

    {:ok, %{rule: rule, basket: basket}}
  end

  describe "free_rule" do
    @describetag type: "free"

    test "substract the value of the free products", %{rule: rule, basket: basket} do
      new_basket = Rule.apply_discount(rule, basket)
      assert new_basket.total_price == 8.0
    end

    @tag min: 3
    test "don't substract anything if not enough", %{rule: rule, basket: basket} do
      new_basket = Rule.apply_discount(rule, basket)
      assert new_basket.total_price == 12.0
    end
  end
end

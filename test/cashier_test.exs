defmodule CashierTest do
  @moduledoc """
    Public interface tests
  """

  use ExUnit.Case, async: true
  doctest Cashier

  describe ".get_product_info" do
    test "returns the product info" do
      {:ok, product} = Cashier.get_product_info("GR1")

      assert product.code == "GR1"
      assert product.name == "Green Tea"
      assert product.price == 3.11
    end

    test "returns :not_found when products do not exists" do
      {:error, reason} = Cashier.get_product_info("invalid")

      assert reason == :not_found
    end
  end
end

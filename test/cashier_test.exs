defmodule CashierTest do
  @moduledoc """
    Public interface tests
  """

  use ExUnit.Case, async: true

  describe ".find_product_by_code" do
    test "returns the product info" do
      {:ok, product} = Cashier.find_product_by_code("GR1")

      assert product.code == "GR1"
      assert product.name == "Green Tea"
      assert product.price == 3.11
    end

    test "returns :not_found when products do not exists" do
      {:error, reason} = Cashier.find_product_by_code("invalid")

      assert reason == :not_found
    end
  end
end

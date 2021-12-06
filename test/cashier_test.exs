defmodule CashierTest do
  @moduledoc """
    Public interface tests
  """

  use ExUnit.Case, async: true

  describe ".find_product_by_code!" do
    test "returns the product info" do
      product = Cashier.find_product_by_code("GR1")

      assert product.code == "GR1"
      assert product.name == "Green Tea"
      assert product.price == 3.11
    end

    test "returns nil when products do not exists" do
      assert Cashier.find_product_by_code("invalid") == nil
    end
  end

  describe ".calculate_total_price" do
    test "gets a green tea for free" do
      assert_in_delta(Cashier.calculate_total_price("GR1,SR1,GR1,GR1,CF1"), 22.45, 0.1)
    end

    test "use reduced price for strawberries" do
      assert_in_delta(Cashier.calculate_total_price("SR1,SR1,GR1,SR1"), 16.61, 0.1)
    end

    test "use fraction price for coffee" do
      assert_in_delta(Cashier.calculate_total_price("GR1,CF1,SR1,CF1,CF1"), 30.57, 0.1)
    end

    test "no discounts" do
      assert_in_delta(Cashier.calculate_total_price("GR1,CF1,SR1"), 19.34, 0.1)
    end
  end
end

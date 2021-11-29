defmodule Cashier.BasketTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Cashier.Basket
  alias Cashier.Product

  setup do
    products = [
      Product.new(%{code: "1", price: "1.0"}),
      Product.new(%{code: "1", price: "1.0"}),
      Product.new(%{code: "2", price: "2.0"}),
      Product.new(%{code: "3", price: "3.0"})
    ]

    {:ok, %{basket: Basket.new(products), products: products}}
  end

  describe ".new" do
    test "calculates quantities", %{basket: basket} do
      assert basket.quantities_by_code == %{
               "1" => 2,
               "2" => 1,
               "3" => 1
             }
    end

    test "sets products by code", %{basket: basket, products: products} do
      assert basket.products_by_code == %{
               "1" => Product.new(%{code: "1", price: "1.0"}),
               "2" => Product.new(%{code: "2", price: "2.0"}),
               "3" => Product.new(%{code: "3", price: "3.0"})
             }
    end

    test "calculates total_price", %{basket: basket} do
      assert basket.total_price == 7.0
    end
  end

  describe ".reduce_total_price" do
    test "decreases basket total_price", %{basket: basket} do
      new_basket = Basket.reduce_total_price(basket, 1.5)
      assert new_basket.total_price == 5.5
    end

    test "sets total_price to 0 when discount is bigger", %{basket: basket} do
      new_basket = Basket.reduce_total_price(basket, 100.0)
      assert new_basket.total_price == 0.0
    end
  end
end

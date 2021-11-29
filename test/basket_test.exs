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
    @describetag :skip

    test "calculates quantities", %{basket: basket} do
      assert basket.quantities_by_code == %{
               "1" => 2,
               "2" => 1,
               "3" => 1
             }
    end

    test "sets products", %{basket: basket, products: products} do
      assert basket.products == products
    end

    test "calculates total_price", %{basket: basket} do
      assert basket.total_price == 7.0
    end
  end
end

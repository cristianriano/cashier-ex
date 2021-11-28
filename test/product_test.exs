defmodule ProductTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Cashier.Product

  describe ".new" do
    test "parses correctly the price" do
      product = Product.new(%{code: "Test", price: "€23.45"})
      assert product.price == 23.45
    end

    test "fails when price does not have cents" do
      product = Product.new(%{code: "Test", price: "€23"})
      assert product == nil
    end

    test "allows string keys" do
      product = Product.new(%{"code" => "T", "name" => "Test", "price" => "€ 1.23"})

      assert product.code == "T"
      assert product.name == "Test"
      assert product.price == 1.23
    end
  end
end

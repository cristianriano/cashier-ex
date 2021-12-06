defmodule ProductRepoTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Cashier.ProductRepo

  test "loads correctly all the products" do
    products = ProductRepo.find_all()
    assert Enum.count(products) == 3
  end

  test "search correctly by product code" do
    {:ok, product} = ProductRepo.find_product_by_code("GR1")
    assert product.code == "GR1"
  end

  test "returns not found when product dont exists" do
    {:error, reason} = ProductRepo.find_product_by_code("ER99")
    assert reason == :not_found
  end
end

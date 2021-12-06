defmodule ProductRepoTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Cashier.ProductRepo

  test "loads correctly all the products" do
    products = ProductRepo.find_all()
    assert Enum.count(products) == 3
  end

  test "search correctly by product code" do
    product = ProductRepo.find_product_by_code!("GR1")
    assert product.code == "GR1"
  end

  test "raise error when product doesn't exists" do
    assert_raise MatchError, fn ->
      ProductRepo.find_product_by_code!("ER99")
    end
  end
end

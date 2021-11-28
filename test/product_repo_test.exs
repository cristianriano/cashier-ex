defmodule ProductRepoTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Cashier.ProductRepo

  setup %{file_path: file_path} do
    pid_reply = start_supervised({ProductRepo, file_path: file_path, name: ProductRepoTest})

    {:ok, %{pid_reply: pid_reply}}
  end

  @tag file_path: Application.compile_env!(:cashier, :products_file)
  test "loads correctly all the products", %{pid_reply: {:ok, pid}} do
    products = GenServer.call(pid, :find_all)
    assert Enum.count(products) == 3
  end

  @tag file_path: "invalid/products.yml"
  test "stops the repo if file is invalid", %{pid_reply: {status, message}} do
    assert status == :error
  end
end

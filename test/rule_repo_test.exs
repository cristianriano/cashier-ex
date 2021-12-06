defmodule RuleRepoTest do
  @moduledoc false

  use ExUnit.Case, async: false

  alias Cashier.RuleRepo

  test "loads correctly all the rules" do
    rules = RuleRepo.find_all()
    assert Enum.count(rules) == 3
  end

  test "search correctly by rule target" do
    {:ok, rules} = RuleRepo.find_rules_by_target("GR1")
    assert Enum.count(rules) == 1
  end
end

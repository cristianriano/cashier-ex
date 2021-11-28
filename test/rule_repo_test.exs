defmodule RuleRepoTest do
  @moduledoc false

  use ExUnit.Case, async: false

  alias Cashier.RuleRepo

  setup %{file_path: file_path} do
    pid_reply = start_supervised({RuleRepo, file_path: file_path, name: RuleRepoTest})

    {:ok, %{pid_reply: pid_reply}}
  end

  describe "with correct rules_file" do
    @describetag file_path: Application.compile_env!(:cashier, :rules_file)

    test "loads correctly all the rules", %{pid_reply: {:ok, pid}} do
      rules = GenServer.call(pid, :find_all)
      assert Enum.count(rules) == 3
    end

    test "search correctly by rule target", %{pid_reply: {:ok, pid}} do
      {:ok, rules} = GenServer.call(pid, {:find_by_target, "GR1"})
      assert Enum.count(rules) == 1
    end
  end

  @tag file_path: "invalid/rules.yml"
  test "stops the repo if file is invalid", %{pid_reply: {status, _message}} do
    assert status == :error
  end
end

defmodule Cashier.RuleRepo do
  @moduledoc """
    This module is a GenServer which contains all the rules loaded during start up
  """
  use GenServer

  require Logger

  alias Cashier.Rule

  @rules_file File.read!(Application.compile_env!(:cashier, :rules_file))

  @spec find_rules_by_target(module(), Rule.target()) :: {:ok, list(Rule.t())}
  def find_rules_by_target(module, target) do
    GenServer.call(module, {:find_by_target, target})
  end

  @spec find_rules_by_target(Rule.target()) :: {:ok, list(Rule.t())}
  def find_rules_by_target(target) do
    find_rules_by_target(__MODULE__, target)
  end

  @spec find_all(module()) :: {:ok, list(Rule.t())}
  def find_all(module) do
    GenServer.call(module, :find_all)
  end

  @spec find_all() :: {:ok, list(Rule.t())}
  def find_all do
    find_all(__MODULE__)
  end

  def handle_call({:find_by_target, target}, _from, %{rules: rules} = state) do
    {:reply, {:ok, find_by_target(target, rules)}, state}
  end

  def handle_call(:find_all, _from, %{rules: rules} = state) do
    {:reply, rules, state}
  end

  def start_link(args) do
    name = Keyword.get(args, :name, __MODULE__)

    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def init(_) do
    case load_rules() do
      {:ok, rules} -> {:ok, %{rules: rules}}
      {:error, reason} -> {:stop, reason}
    end
  end

  @spec find_by_target(Rule.target(), list(Rule.t())) :: list(Rule.t())
  defp find_by_target(query, rules) do
    Enum.filter(rules, fn %Rule{target: target} -> query == target end)
  end

  @spec load_rules() :: {:ok, list(Rule.t())} | {:error, String.t()}
  defp load_rules do
    @rules_file
    |> YamlElixir.read_from_string()
    |> process_file()
  end

  @spec process_file({:ok, map()} | {:error, any()}) ::
          {:ok, list(Rule.t())} | {:error, String.t()}
  defp process_file({:ok, %{"rules" => rules}}) do
    parsed_rules =
      rules
      |> Enum.map(&Rule.new/1)
      |> Enum.reject(&is_nil/1)

    {:ok, parsed_rules}
  end

  defp process_file({:error, error}) do
    Logger.error(error.message)
    {:error, error.message}
  end
end

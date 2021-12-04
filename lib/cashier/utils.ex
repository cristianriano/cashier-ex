defmodule Cashier.Utils do
  @moduledoc """
    Common utility functions
  """

  @spec transform_keys(map()) :: map()
  def transform_keys(args) do
    for {key, val} <- args, into: %{} do
      if is_atom(key), do: {key, val}, else: {String.to_existing_atom(key), val}
    end
  end

  @spec parse_path(String.t()) :: String.t()
  def parse_path(path) do
    File.cwd!()
    |> Path.join(path)
  end
end

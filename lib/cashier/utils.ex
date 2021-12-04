defmodule Cashier.Utils do
  @moduledoc """
    Common utility functions
  """

  def transform_keys(args) do
    for {key, val} <- args, into: %{} do
      if is_atom(key), do: {key, val}, else: {String.to_existing_atom(key), val}
    end
  end
end

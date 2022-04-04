defmodule Cashier.Repo.NotFound do
  @moduledoc """
    Raised when an entity is not found
  """

  defexception [:message]
end

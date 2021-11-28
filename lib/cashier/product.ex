defmodule Cashier.Product do
  @moduledoc """
    Represents a product
  """

  @type t() :: %__MODULE__{
    code: String.t(),
    name: String.t(),
    price: float()
  }

  @enforce_keys [:code]
  defstruct code: "",
            name: "",
            price: 0.0
end

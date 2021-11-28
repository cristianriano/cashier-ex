defmodule Cashier.Product do
  @moduledoc """
    Represents a product
  """

  @type code() :: String.t()
  @type t() :: %__MODULE__{
          code: code(),
          name: String.t(),
          price: float()
        }

  @enforce_keys [:code]
  defstruct code: nil,
            name: "",
            price: 0.0

  @price_regex Regex.compile!("[0-9]+\\.[0-9]{1,2}")

  @spec new(map()) :: t()
  def new(args) when is_map(args) do
    new_args = transform_keys(args)

    __MODULE__
    |> struct!(new_args)
    |> parse_price()
  end

  defp transform_keys(args) do
    for {key, val} <- args, into: %{} do
      if is_atom(key), do: {key, val}, else: {String.to_existing_atom(key), val}
    end
  end

  defp parse_price(%__MODULE__{price: price} = product) do
    case Regex.run(@price_regex, price) do
      [value] -> %__MODULE__{product | price: String.to_float(value)}
      _ -> nil
    end
  end
end

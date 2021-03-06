defmodule Ecto.Base62Id do
  @moduledoc """

  Ecto custom type for ExtraPost API object ids
  seamless transformation to base62 and back to int.

  """
  @type t :: String.t()

  @behaviour Ecto.Type

  @impl Ecto.Type
  def type, do: :integer

  @impl Ecto.Type
  def cast(int) when is_integer(int), do: {:ok, int}
  def cast(base62) when is_binary(base62), do: {:ok, :base62.decode(base62)}
  def cast(_other), do: :error

  @impl Ecto.Type
  def load(int) when is_integer(int), do: {:ok, :base62.encode(int)}
  def load(_other), do: :error

  @impl Ecto.Type
  def dump(base62) when is_binary(base62), do: {:ok, :base62.decode(base62)}
  def dump(int) when is_integer(int), do: {:ok, int}
  def dump(_other), do: :error
  
  @doc """

  ## Examples

      iex> equal?(1, 1)
      true

      iex> equal?(1, 2)
      false

      iex> equal?(1, nil)
      false

      iex> equal?(100, "1c)
      true

      iex> equal("1c", "1c")
      true

  """

  @impl Ecto.Type
  def equal?(a, b) when (is_integer(a) and is_integer(b)) or (is_binary(a) and is_binary(b)),
    do: a == b

  def equal?(a, b) when is_binary(a), do: equal?(:base62.decode(a), b)
  def equal?(a, b) when is_binary(b), do: equal?(a, :base62.decode(b))
  def equal?(_, _), do: false

  @impl Ecto.Type
  def embed_as(_format), do: :self

  # TODO: write correct generator
  # This function is called, if autogenerate: true is set on primary key
  # But, it is not called when doing Repo.insert_all()
  # Thats why we use Postgres stored proc for now.
  def autogenerate do
    (:rand.uniform() * 1_000_000_000_000_000_000) |> round()
  end
end

defmodule Json do
  require Json.Decoder
  require Json.Encoder

  @moduledoc """
  Json - module for encoding/decoding json format.
  """

  @doc """
  encodes elixir primitives to Json

  Returns: `json`
  """
  def encode(x) do
    Json.Encoder.encode(x)
  end

  @doc """
  decodes json to elixir primitives.

  Returns: `{:error, error}` or `elixir result(primitive)`
  """
  def decode(json) do
    case Json.Decoder.decode(json) do
      {:ok, result, _} -> result
      e -> e
    end
  end

  @doc """
  decodes json to elixir primitives.

  Returns: `{:error, error}` or `{:ok, result, rest}` where rest is the rest part of given string.
  """
  def decode!(json) do
    Json.Decoder.decode(json)
  end
end

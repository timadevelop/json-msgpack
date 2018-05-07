defmodule MsgPack do
  require MsgPack.Decoder
  require MsgPack.Encoder

  @moduledoc """
  MsgPack - module for encoding/decoding msgpack format.
  """

  @doc """
  encodes elixir primitives to MsgPack

  Returns: `msgpack`
  """
  def encode(x) do
    MsgPack.Encoder.encode(x)
  end

  @doc """
  decodes msgpack to elixir primitives.

  Returns: `{:error, error}` or `elixir result(primitive)`
  """
  def decode(msg) do
    case MsgPack.Decoder.decode(msg) do
      {:ok, result, _} -> result
      e -> e
    end
  end

  @doc """
  decodes msgpack to elixir primitives.

  Returns: `{:error, error}` or `{:ok, result, rest}` where rest is the rest part of given string.
  """
  def decode!(msg) do
    MsgPack.Decoder.decode(msg)
  end
end

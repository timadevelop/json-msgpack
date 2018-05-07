defmodule Json.Encoder do
  @moduledoc """
  Encode for json - encodes elixir primitives to json.

  See [json spec](https://stackoverflow.com/questions/383692/what-is-json-and-why-would-i-use-it/383699#383699)
  """
  def encode(number) when is_number(number) do
    to_string(number)
  end

  def encode(nil) do
    "null"
  end

  def encode(atom) when is_atom(atom) do
    to_string(atom)
  end

  def encode(list) when is_list(list) do
    "[" <> Enum.map_join(list, ",", fn x -> encode(x) end) <> "]"
  end

  def encode(map) when is_map(map) do
    "{" <>
      Enum.map_join(map, ",", fn {key, value} ->
        encode(key) <> ":" <> encode(value)
      end) <> "}"
  end

  def encode(string) when is_bitstring(string) do
    "\"" <> encode_string(string) <> "\""
  end

  defp encode_string(<<?"::utf8, rest::binary>>) do
    "\"" <> encode_string(rest)
  end

  defp encode_string(<<?\n::utf8, rest::binary>>) do
    "\\n" <> encode_string(rest)
  end

  defp encode_string(<<?\t::utf8, rest::binary>>) do
    "\\t" <> encode_string(rest)
  end

  defp encode_string(<<?\b::utf8, rest::binary>>) do
    "\\b" <> encode_string(rest)
  end

  defp encode_string(<<?\\::utf8, rest::binary>>) do
    "\\\\" <> encode_string(rest)
  end

  defp encode_string(<<?\r::utf8, rest::binary>>) do
    "\\r" <> encode_string(rest)
  end

  defp encode_string(<<?\f::utf8, rest::binary>>) do
    "\\f" <> encode_string(rest)
  end

  defp encode_string(<<>>) do
    <<>>
  end

  defp encode_string(<<char::utf8, rest::binary>>) do
    <<char::utf8>> <> encode_string(rest)
  end
end

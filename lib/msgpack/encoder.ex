defmodule MsgPack.Encoder do
  # macro for power of 2
  defmacro pow2(x) do
    quote do
      unquote(:math.pow(2, x))
    end
  end

  # nil
  def encode(nil) do
    <<0xC0::size(8)>>
  end

  #
  # boolean
  #
  def encode(false) do
    <<0xC2::size(8)>>
  end

  def encode(true) do
    <<0xC3::size(8)>>
  end

  #
  # number
  #
  def encode(number)
      when is_integer(number) and number > 0 and number < pow2(7) do
    <<0b0::size(1), number::integer-unsigned-size(7)>>
  end

  def encode(number)
      when is_integer(number) and number > 0 and number < pow2(8) do
    <<0xCC::size(8), number::integer-unsigned-size(8)>>
  end

  def encode(number)
      when is_integer(number) and number > 0 and number < pow2(16) do
    <<0xCD::size(8), number::integer-big-unsigned-size(16)>>
  end

  def encode(number)
      when is_integer(number) and number > 0 and number < pow2(32) do
    <<0xCD::size(8), number::integer-big-unsigned-size(32)>>
  end

  def encode(number)
      when is_integer(number) and number > 0 and number < pow2(64) do
    <<0xCF::size(8), number::integer-big-unsigned-size(64)>>
  end

  def encode(number) when is_integer(number) and -number < pow2(5) do
    <<0b111::size(3), -number::integer-signed-size(5)>>
  end

  def encode(number) when is_integer(number) and -number < pow2(8) do
    <<0xCF::size(8), number::integer-signed-size(8)>>
  end

  def encode(number) when is_integer(number) and -number < pow2(16) do
    <<0xCD::size(8), number::integer-big-signed-size(16)>>
  end

  def encode(number) when is_integer(number) and -number < pow2(32) do
    <<0xCD::size(8), number::integer-big-signed-size(32)>>
  end

  def encode(number) when is_integer(number) and -number < pow2(64) do
    <<0xCF::size(8), number::integer-big-signed-size(64)>>
  end

  #
  # float
  #
  def encode(float) when is_float(float) do
    <<0xCB::size(8), float::float-big-size(64)>>
  end

  #
  # string
  #
  def encode(<<string::binary>>)
      when is_bitstring(string) and byte_size(string) < pow2(4) do
    <<0b101::size(3), byte_size(string)::unsigned-integer-size(5), string::binary>>
  end

  def encode(<<string::binary>>)
      when is_bitstring(string) and byte_size(string) < pow2(8) do
    <<0xD9::size(8), byte_size(string)::unsigned-integer-size(8), string::binary>>
  end

  def encode(<<string::binary>>)
      when is_bitstring(string) and byte_size(string) < pow2(16) do
    <<0xDA::size(8), byte_size(string)::unsigned-integer-size(16), string::binary>>
  end

  def encode(<<string::binary>>)
      when is_bitstring(string) and byte_size(string) < pow2(32) do
    <<0xDB::size(8), byte_size(string)::unsigned-integer-size(32), string::binary>>
  end

  #
  # list
  #
  def encode(list) when is_list(list) and length(list) < pow2(4) do
    <<0b1001::size(4), length(list)::unsigned-integer-size(4), encode_list(list)::binary>>
  end

  def encode(list) when is_list(list) and length(list) < pow2(16) do
    <<0xDC::size(8), length(list)::unsigned-integer-size(16), encode_list(list)::binary>>
  end

  def encode(list) when is_list(list) and length(list) < pow2(32) do
    <<0xDD::size(8), length(list)::unsigned-integer-size(32), encode_list(list)::binary>>
  end

  #
  # map
  #
  def encode(map) when is_map(map) and map_size(map) < pow2(4) do
    <<0b1000::size(4), map_size(map)::unsigned-integer-size(4), encode_map(map)::binary>>
  end

  def encode(map) when is_map(map) and map_size(map) < pow2(16) do
    <<0xDE::size(8), map_size(map)::unsigned-integer-size(16), encode_map(map)::binary>>
  end

  def encode(map) when is_map(map) and map_size(map) < pow2(32) do
    <<0xDF::size(8), map_size(map)::unsigned-integer-size(32), encode_map(map)::binary>>
  end

  #
  # helpers
  #
  defp encode_map(map) when is_map(map) do
    Enum.map_join(map, fn {key, value} ->
      encode(key) <> encode(value)
    end)
  end

  defp encode_list(list) when is_list(list) do
    Enum.map_join(list, fn x -> encode(x) end)
  end
end

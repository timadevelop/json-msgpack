defmodule Json.Decoder do
  @doc """
  decode for each type of json object
  """

  # boolean -> boolean
  def decode("false" <> <<rest::binary>>) do
    {:ok, false, String.trim_leading(rest)}
  end

  def decode("true" <> <<rest::binary>>) do
    {:ok, true, String.trim_leading(rest)}
  end

  # null -> nil
  def decode("null" <> <<rest::binary>>) do
    {:ok, nil, String.trim_leading(rest)}
  end

  # number -> number
  def decode(<<?-::utf8, number::utf8, _::binary>> = str) when number in ?0..?9 do
    decode_number(str)
  end

  def decode(<<number::utf8, _::binary>> = str) when number in ?0..?9 do
    decode_number(str)
  end

  # string -> string
  def decode(<<?"::utf8, rest::binary>>) do
    decode_string(rest)
  end

  # array -> list
  def decode(<<?[::utf8, rest::binary>>) do
    decode_array(rest)
  end

  # object -> map
  def decode(<<?{::utf8, rest::binary>>) do
    decode_map(rest)
  end

  # otherwise
  def decode(_) do
    {:error, :invalid_json}
  end

  #####
  #
  # Decoding
  #
  #####

  #
  # Decode number
  #
  defp decode_number(candidate) do
    case Integer.parse(candidate) do
      :error -> {:error, :invalid_number}
      {_, <<?.::utf8, _::binary>>} -> decode_floating(candidate)
      {_, <<?e::utf8, _::binary>>} -> decode_floating(candidate)
      {_, <<?E::utf8, _::binary>>} -> decode_floating(candidate)
      {result, rest} -> {:ok, result, String.trim_leading(rest)}
    end
  end

  # decode float
  defp decode_floating(candidate) do
    try do
      case Float.parse(candidate) do
        :error -> {:error, :invalid_float}
        {result, rest} -> {:ok, result, String.trim_leading(rest)}
      end
    rescue
      e -> {:error, :float_parse, e, candidate}
    end
  end

  #
  # Decode string
  #
  defp decode_string(string) do
    decode_string(string, "")
  end
  # ennds with "
  defp decode_string(<<?"::utf8, rest::binary>>, decoded) do
    {:ok, decoded, rest}
  end

  # empty binary
  defp decode_string(<<>>, _) do
    {:error, :unexpected_end_of_string}
  end

  # \e
  defp decode_string(<<?\\::utf8, ?n::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> "\n")
  end

  defp decode_string(<<?\\::utf8, ?r::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> "\r")
  end

  defp decode_string(<<?\\::utf8, ?t::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> "\t")
  end

  defp decode_string(<<?\\::utf8, ?b::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> "\b")
  end

  defp decode_string(<<?\\::utf8, ?f::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> "\f")
  end

  defp decode_string(<<?\\::utf8, ?\\::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> "\\")
  end

  defp decode_string(<<?\\::utf8, ?/::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> "/")
  end

  # other chars, finally
  defp decode_string(<<char::utf8, rest::binary>>, decoded) do
    decode_string(rest, decoded <> <<char::utf8>>)
  end



  #
  # Decode array
  #
  defp decode_array(candidate) do
    decode_array(candidate, [])
  end

  defp decode_array(<<>>, _) do
    {:error, :unexpected_end_of_array}
  end

  # end of array, reverse decoded becase of [ | ]
  defp decode_array(<<?]::utf8, rest::binary>>, decoded_array) do
    {:ok, Enum.reverse(decoded_array), String.trim_leading(rest)}
  end

  # next element in array
  defp decode_array(<<?,::utf8, rest::binary>>, decoded_array) do
    decode_array(String.trim_leading(rest), decoded_array)
  end


  # decode string, add it to the beginning of already decoded array
  defp decode_array(string, decoded_array) do
    case decode(string) do
      {:error, e} -> {:error, e}
      {:ok, result, rest} ->
        decode_array(String.trim_leading(rest), [result | decoded_array])
    end
  end
  #
  # Decode map
  #
  defp decode_map(candidate) do
    {:error, :todo}
  end
end

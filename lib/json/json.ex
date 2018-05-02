defmodule Json do

  def encode(x) do
    Json.Encoder.encode(x)
  end

  def decode(json) do
    case Json.Decoder.decode(json) do
      {:ok, result, rest} -> result
      e -> e
    end
  end

end

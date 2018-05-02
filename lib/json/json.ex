defmodule Json do

  def encode(x) do
    Json.Encoder.encode(x)
  end

  def decode(json) do
    Json.Decoder.decode(json)
  end

end

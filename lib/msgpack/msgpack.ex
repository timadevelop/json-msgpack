defmodule MsgPack do

  def encode(x) do
    MsgPack.Encoder.encode(x)
  end

  def decode(msg) do
    case MsgPack.Decoder.decode(msg) do
      {:ok, result, rest} -> result
      e -> e
    end
  end

end

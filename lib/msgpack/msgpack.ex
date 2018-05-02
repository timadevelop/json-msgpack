defmodule MsgPack do

  def encode(x) do
    MsgPack.Encoder.encode(x)
  end

  def decode(msg) do
    MsgPack.Decoder.decode(msg)
  end
end

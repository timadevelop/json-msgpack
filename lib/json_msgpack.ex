defmodule JsonMsgpack do
  @moduledoc """
  Documentation for JsonMsgpack.
  """

  @doc """
  Hello world.

  ## Examples

      iex> JsonMsgpack.hello
      :world

  """
  def hello do
    :world
  end


  def jsonToMsgPack(json) do
    Json.decode(json)
    |> MsgPack.encode()
  end

  def msgPackToJson(msg) do
    MsgPack.decode(msg)
    |> Json.encode()
  end

  def decodeJson(json) do
    Json.decode(json)
  end

  def encodeJson(x) do
    Json.encode(x)
  end

  def decodeMsgPack(msg) do
    MsgPack.decode(msg)
  end

  def encodeMsgPack(x) do
    MsgPack.encode(x)
  end

end

defmodule JsonMsgpack do
  @moduledoc """
  Documentation for JsonMsgpack.

  JsonMsgPack is a simple module for converting between JSON and MsgPack.
  """

  @doc """
  Converts json to msgpack.

  Returns `{:error, error_code} or msgpack result`.
  ## Examples
      -iex(1)> msg = JsonMsgpack.jsonToMsgPack("{\"compact\":true,\"schema\":0}")
      <<130, 167, 99, 111, 109, 112, 97, 99, 116, 195, 166, 115, 99, 104, 101, 109,
        97, 224>>

      -iex(2)> byte_size(msg)
      18
  """
  def jsonToMsgPack(json) do
    Json.decode(json)
    |> MsgPack.encode()
  end

  @doc """
  Converts msgPack to json

  Returns `{:error, error_code} or json result`.

  ## Examples
      -iex(1)> msg = JsonMsgpack.jsonToMsgPack("{\"compact\":true,\"schema\":0}")
      <<130, 167, 99, 111, 109, 112, 97, 99, 116, 195, 166, 115, 99, 104, 101, 109,
        97, 224>>

      -iex(2)> json = JsonMsgpack.msgPackToJson(msg)
      "{\"compact\":true,\"schema\":0}"

      -iex(3)> byte_size(json)
      27
  """
  def msgPackToJson(msg) do
    MsgPack.decode(msg)
    |> Json.encode()
  end

  @doc """
  decodes JSON to elixir primitives

  Returns `{:error, error_code} or elixir result`.

  ## Examples
      -iex(1)> elixir_result = JsonMsgpack.decodeJson("{\"compact\":true,\"schema\":0}")
      %{"compact" => true, "schema" => 0}

      -iex(2)> elixir_result = JsonMsgpack.decodeJson("{\"compact\":true,\"schema\:0}")
      {:error, :unexpected_end_of_string}
  """
  def decodeJson(json) do
    Json.decode(json)
  end

  @doc """
  encodes elixir to json

  Returns `{:error, error_code} or json result`.

  ## Examples

      -iex(1)> elixir_result = JsonMsgpack.decodeJson("{\"compact\":true,\"schema\":0}")
      %{"compact" => true, "schema" => 0}

      -iex(16)> JsonMsgpack.encodeJson(elixir_result)
      "{\"compact\":true,\"schema\":0}"

  """
  def encodeJson(x) do
    Json.encode(x)
  end

  @doc """
  decodes msgpack to elixir

  Returns `{:error, error_code} or elixir result`.

  ## Examples
      -iex(1)> msg = JsonMsgpack.jsonToMsgPack("{\"compact\":true,\"schema\":0}")
      <<130, 167, 99, 111, 109, 112, 97, 99, 116, 195, 166, 115, 99, 104, 101, 109,
        97, 224>>

      -iex(2)> JsonMsgpack.decodeMsgPack(msg)
      %{"compact" => true, "schema" => 0}

  """
  def decodeMsgPack(msg) do
    MsgPack.decode(msg)
  end

  @doc """
  encodes eixir to msgpack

  Returns `{:error, error_code} or msgpack result`.

  ## Examples
      -iex(1)> ep = %{"compact" => true, "schema" => 0}
      %{"compact" => true, "schema" => 0}

      -iex(2)> msg = JsonMsgpack.encodeMsgPack(ep)
      <<130, 167, 99, 111, 109, 112, 97, 99, 116, 195, 166, 115, 99, 104, 101, 109,
        97, 224>>

      -iex(3)> byte_size(msg)
      18

  """
  def encodeMsgPack(x) do
    MsgPack.encode(x)
  end

end

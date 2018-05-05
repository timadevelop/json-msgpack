defmodule JsonMsgpackTest do
  use ExUnit.Case
  doctest JsonMsgpack

  test "greets the world" do
    assert JsonMsgpack.hello() === :world
  end

  test "decode json numbers" do
    assert JsonMsgpack.decodeJson("1") === 1
    assert JsonMsgpack.decodeJson("-12345323") === -12_345_323
    assert JsonMsgpack.decodeJson("1.01") === 1.01
    assert JsonMsgpack.decodeJson("-231.01") === -231.01
    assert JsonMsgpack.decodeJson("1e01") === 10.0

    assert JsonMsgpack.decodeJson("-12E457") ===
             {:error, :float_parse, %ArgumentError{message: "argument error"}, "-12E457"}
  end

  test "decode json strings" do
    test_string_decoding([
      "1123",
      "string12345",
      "soadjknoOKJOJO\'asd[pk]",
      "-123IKJN IJN - -q3 '/' dskopf/ smd sdm",
      "why yes and w'.ay' not? ha1! /\/\/\/\/\/\/\/"
    ])

    assert Json.decode("\"ads12") === {:error, :unexpected_end_of_string}
  end

  defp test_string_decoding(arr) do
    Enum.each(arr, fn e when is_binary(e) ->
      assert JsonMsgpack.decodeJson("\"#{e}\"") === e
    end)
  end

  test "decode json arrays" do
    assert Json.decode("[]") === []

    assert Json.decode("[[], [[]], [[[[],[]],[]],[[[],[]]]],[],[]]") === [
             [],
             [[]],
             [[[[], []], []], [[[], []]]],
             [],
             []
           ]

    assert Json.decode("[-1.2341, -0.121, 0, \"asdlm\"]") === [-1.2341, -0.121, 0, "asdlm"]

    assert Json.decode("[-1.2341, [1,2,3,3], -0.121, 0, \"asdlm\", []]") === [
             -1.2341,
             [1, 2, 3, 3],
             -0.121,
             0,
             "asdlm",
             []
           ]

    assert Json.decode("[1,2,3,4,5, [1234, 1234]") === {:error, :unexpected_end_of_array}
  end

  test "decode json objects to maps" do
    assert Json.decode(
             "{\"key\": [\"value \"], \"what?1\": {\"nothing\" : null}, \"null\" : null}"
           ) === %{"key" => ["value "], "what?1" => %{"nothing" => nil}, "null" => nil}
  end

  test "encode numbers" do
    # int
    assert Json.encode(1) === "1"
    assert Json.encode(-1) === "-1"
    assert Json.encode(12345) === "12345"
    # floats
    assert Json.encode(0.1) === "0.1"
    assert Json.encode(0.001) === "0.001"
    assert Json.encode(-0.001) === "-0.001"
    assert Json.encode(2134.2341) === "2134.2341"
  end

  test "encode strings" do
    assert Json.encode("i am an string!") === "\"i am an string!\""

    assert Json.encode("Hi, here: \"is some text\", \n and newline") ===
             "\"Hi, here: \"is some text\", \\n and newline\""
  end

  test "encode arrays" do
    assert Json.encode([]) === "[]"

    assert Json.encode([[], [[]], [[[[], []], []], [[[], []]]], [], []]) ===
             "[[],[[]],[[[[],[]],[]],[[[],[]]]],[],[]]"

    assert Json.encode([-1.2341, -0.121, 0, "asdlm"]) === "[-1.2341,-0.121,0,\"asdlm\"]"

    assert Json.encode([-1.2341, [1, 2, 3, 3], -0.121, 0, "asdlm", []]) ===
             "[-1.2341,[1,2,3,3],-0.121,0,\"asdlm\",[]]"

    # assert Json.decode("[1,2,3,4,5, [1234, 1234]") === {:error, :unexpected_end_of_array}
  end

  test "encode maps" do
    assert Json.encode(%{"key0" => ["value0"]}) ===
             "{\"key0\":[\"value0\"]}"
    assert Json.encode(%{"key0" => ["value0"], "key1" => %{"v" => 3}}) ===
             "{\"key0\":[\"value0\"],\"key1\":{\"v\":3}}"

    # maps are not ordered in elixir!
    # assert Json.encode(%{"key" => ["value "], "what?1" => %{"nothing" => nil}, "null" => nil}) ===
    # "{\"key\":[\"value \"],\"what?1\":{\"nothing\":null},\"null\":null}"
  end
end

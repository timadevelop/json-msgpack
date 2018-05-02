defmodule JsonMsgpackTest do
  use ExUnit.Case
  doctest JsonMsgpack

  test "greets the world" do
    assert JsonMsgpack.hello() == :world
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
    test_string_decoding(["1123", "string12345",
                          "soadjknoOKJOJO\'asd[pk]",
                          "-123IKJN IJN - -q3 '/' dskopf/ smd sdm",
                          "why yes and w'.ay' not? ha1! /\/\/\/\/\/\/\/"])
    assert Json.decode("\"ads12") === {:error, :unexpected_end_of_string}
  end

  defp test_string_decoding(arr) do
    Enum.each(arr, fn 
      e when is_binary(e) -> 
        assert JsonMsgpack.decodeJson("\"#{e}\"") === e
    end)
  end


  test "decode json arrays" do
    assert Json.decode("[]") === []
    assert Json.decode("[[], [[]], [[[[],[]],[]],[[[],[]]]],[],[]]") === [[], [[]], [[[[],[]],[]],[[[],[]]]],[],[]]
    assert Json.decode("[-1.2341, -0.121, 0, \"asdlm\"]") === [-1.2341, -0.121, 0, "asdlm"]
    assert Json.decode("[-1.2341, [1,2,3,3], -0.121, 0, \"asdlm\", []]") === [-1.2341, [1,2,3,3] , -0.121, 0, "asdlm", []]
    assert Json.decode("[1,2,3,4,5, [1234, 1234]") === {:error, :unexpected_end_of_array}
  end
end

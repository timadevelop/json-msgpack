defmodule JsonMsgpackTest do
  use ExUnit.Case
  doctest JsonMsgpack

  test "greets the world" do
    assert JsonMsgpack.hello() == :world
  end
end

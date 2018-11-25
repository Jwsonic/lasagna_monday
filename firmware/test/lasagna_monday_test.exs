defmodule LasagnaMondayTest do
  use ExUnit.Case
  doctest LasagnaMonday

  test "greets the world" do
    assert LasagnaMonday.hello() == :world
  end
end

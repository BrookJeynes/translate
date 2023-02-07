defmodule TranslationExsTest do
  use ExUnit.Case
  doctest TranslationExs

  test "greets the world" do
    assert TranslationExs.hello() == :world
  end
end

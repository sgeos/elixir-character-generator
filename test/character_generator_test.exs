defmodule CharacterGeneratorTest do
  use ExUnit.Case
  doctest CharacterGenerator

  test "true" do
    assert true == true
  end

  test "application terminates" do
    {:ok, pid} = CharacterGenerator.Application.start(nil, nil)
    %Task{ref: ref} = CharacterGenerator.Application.main_task(pid)
    assert_receive {:DOWN, ^ref, :process, _, :normal}, 100
  end
end


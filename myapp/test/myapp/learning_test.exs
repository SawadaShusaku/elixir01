defmodule Myapp.LearningTest do
  use ExUnit.Case, async: true

  alias Myapp.Learning

  test "lessons/0 returns lesson metadata" do
    lessons = Learning.lessons()
    assert length(lessons) >= 3
    assert Enum.any?(lessons, &(&1.title == "Pattern Matching"))
  end

  test "evaluate_pipeline/1 calculates transformed values" do
    assert {:ok, result} = Learning.evaluate_pipeline("1, 2, 3")
    assert result.numbers == [1, 2, 3]
    assert result.doubled == [2, 4, 6]
    assert result.even_only == [2, 4, 6]
    assert result.sum == 12
  end

  test "evaluate_pipeline/1 rejects invalid tokens" do
    assert {:error, message} = Learning.evaluate_pipeline("1, two, 3")
    assert message =~ "整数"
  end
end

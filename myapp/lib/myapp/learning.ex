defmodule Myapp.Learning do
  @moduledoc """
  Learning helpers used by the tutorial pages.
  """

  @lessons [
    %{
      id: "pattern-matching",
      title: "Pattern Matching",
      description: "値の取り出しと検証を同時に行える Elixir の基本機能です。",
      snippet: """
      {:ok, user} = {:ok, %{name: "Aki", role: :student}}
      %{name: name} = user
      # name => "Aki"
      """
    },
    %{
      id: "pipe-operator",
      title: "Pipe Operator",
      description: "データの流れを左から右へ読める形でつなげます。",
      snippet: """
      [1, 2, 3, 4]
      |> Enum.map(&(&1 * 2))
      |> Enum.filter(&(rem(&1, 3) != 0))
      # => [2, 4, 8]
      """
    },
    %{
      id: "immutability",
      title: "Immutability",
      description: "データは破壊的に変更されず、新しい値を返します。",
      snippet: """
      numbers = [1, 2, 3]
      updated = [0 | numbers]
      # numbers => [1, 2, 3]
      # updated => [0, 1, 2, 3]
      """
    }
  ]

  def lessons, do: @lessons

  def sample_results do
    %{
      pipeline: [1, 2, 3, 4] |> Enum.map(&(&1 * 2)) |> Enum.sum(),
      recursion: factorial(5),
      pattern: greet({:user, "Mika"})
    }
  end

  def evaluate_pipeline(raw_input) when raw_input in [nil, ""] do
    {:error, "数値をカンマ区切りで入力してください。例: 1, 2, 3"}
  end

  def evaluate_pipeline(raw_input) when is_binary(raw_input) do
    tokens =
      raw_input
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))

    with true <- tokens != [],
         {:ok, numbers} <- parse_integers(tokens) do
      doubled = Enum.map(numbers, &(&1 * 2))
      even_only = Enum.filter(doubled, &(rem(&1, 2) == 0))

      {:ok,
       %{
         numbers: numbers,
         doubled: doubled,
         even_only: even_only,
         sum: Enum.sum(even_only)
       }}
    else
      false -> {:error, "入力が空です。例: 3, 6, 9"}
      {:error, :not_integer} -> {:error, "整数のみ入力できます。例: 10, 20, 30"}
    end
  end

  defp parse_integers(tokens) do
    Enum.reduce_while(tokens, {:ok, []}, fn token, {:ok, acc} ->
      case Integer.parse(token) do
        {value, ""} -> {:cont, {:ok, [value | acc]}}
        _ -> {:halt, {:error, :not_integer}}
      end
    end)
    |> case do
      {:ok, values} -> {:ok, Enum.reverse(values)}
      error -> error
    end
  end

  defp factorial(0), do: 1
  defp factorial(n), do: n * factorial(n - 1)

  defp greet({:user, name}), do: "こんにちは、#{name}さん"
end

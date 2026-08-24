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

  @syntax_lessons [
    %{
      id: "01-values-and-types",
      step: 1,
      title: "値と型の基本",
      summary: "Elixir の基本データ型（整数、浮動小数、文字列、アトム、タプル、リスト）を確認します。",
      goals: [
        "値は式として評価されることを理解する",
        "文字列とアトムの違いを把握する",
        "タプルとリストの用途の違いを把握する"
      ],
      concepts: [
        %{
          term: "アトム (`:ok`)",
          concept: "アトムは定数名です。Elixir では `:ok` や `:error` のような状態ラベルとしてよく使います。",
          detail: "文字列と違って比較が高速で、同じ名前なら常に同じ値です。ユーザー入力を `String.to_atom/1` で増やし続けるのは危険です。",
          example: "result = :ok"
        },
        %{
          term: "文字列 (`\"elixir\"`)",
          concept: "文字列はテキストデータです。",
          detail: "画面表示や外部APIとのやり取りは通常文字列を使います。アトムとは用途が異なります。",
          example: "language = \"elixir\""
        },
        %{
          term: "タプル (`{10, 20}`)",
          concept: "タプルは要素数が固定のデータ構造です。",
          detail: "戻り値で `{:ok, value}` のように意味のある組を返すときに使います。",
          example: "point = {10, 20}"
        },
        %{
          term: "リスト (`[:web, :functional]`)",
          concept: "リストは長さが可変の順序付きコレクションです。",
          detail: "複数要素を順番に処理するときに使います。Enum モジュールと組み合わせる場面が多いです。",
          example: "tags = [:web, :functional, :beam]"
        }
      ],
      walkthrough: [
        "`number = 42` と `pi = 3.14` は数値リテラルです。整数と浮動小数は別の型として扱われます。",
        "`language = \"elixir\"` はバイナリ文字列、`status = :ok` はアトムです。比較や用途が異なります。",
        "`point = {10, 20}` は固定長のタプルで、`tags = [...]` は可変長のリストです。"
      ],
      snippet: """
      number = 42
      pi = 3.14
      language = "elixir"
      status = :ok
      point = {10, 20}
      tags = [:web, :functional, :beam]
      """
    },
    %{
      id: "02-variables-and-patterns",
      step: 2,
      title: "変数束縛とパターンマッチ",
      summary: "Elixir の代入は束縛です。パターンマッチで値を取り出す方法を学びます。",
      goals: [
        "変数は不変で再束縛できることを理解する",
        "タプルやマップから値を取り出す",
        "マッチ失敗時にエラーになることを確認する"
      ],
      concepts: [
        %{
          term: "束縛 (binding)",
          concept: "Elixir の `=` は代入というより『名前を値に結びつける』操作です。",
          detail: "同じ変数名に別の値を置くときは再束縛になります。過去の値を書き換えるわけではありません。",
          example: "score = 10\nscore = score + 5"
        },
        %{
          term: "パターンマッチ",
          concept: "左辺の形（パターン）と右辺の値が一致するか検査しながら値を取り出す機能です。",
          detail: "一致しないと `MatchError` になります。これがデータ検証として働きます。",
          example: "{:ok, user} = {:ok, %{name: \"Mika\"}}"
        },
        %{
          term: "マップ取り出し (`%{name: name}`)",
          concept: "マップの特定キーをパターンで取り出せます。",
          detail: "必要なキーがなければマッチ失敗になります。想定フォーマットの確認にも使えます。",
          example: "%{name: name} = user"
        }
      ],
      walkthrough: [
        "`{:ok, user} = ...` はタプルの1要素目が `:ok` であることを確認しつつ、2要素目を `user` に束縛します。",
        "`%{name: name} = user` でマップから `:name` キーの値を取り出して `name` へ束縛します。",
        "`score = score + 5` は破壊的更新ではなく、`score` という名前への再束縛です。"
      ],
      snippet: """
      {:ok, user} = {:ok, %{name: "Mika"}}
      %{name: name} = user
      # name => "Mika"

      score = 10
      score = score + 5
      # score => 15
      """
    },
    %{
      id: "03-control-flow",
      step: 3,
      title: "条件分岐: if / case / cond",
      summary: "複数分岐を安全に書くための `case` と `cond` を中心に学びます。",
      goals: [
        "if は2分岐、case/cond は多分岐に向くことを理解する",
        "case でパターンごとに処理を分ける",
        "cond で条件式を上から評価する"
      ],
      concepts: [
        %{
          term: "`if` と `cond` の違い",
          concept: "`if` は真偽値1条件に向き、`cond` は複数条件の優先評価に向きます。",
          detail: "初学者は『3分岐以上なら cond』と覚えると読みやすいコードを書きやすいです。",
          example: "cond do\n  x < 0 -> :negative\n  true -> :other\nend"
        },
        %{
          term: "式としての分岐",
          concept: "Elixir の分岐は値を返す式です。",
          detail: "分岐結果をそのまま変数に束縛して次の処理に渡せます。",
          example: "label = if n > 0, do: :pos, else: :non_pos"
        },
        %{
          term: "デフォルト分岐 (`true -> ...`)",
          concept: "`cond` の最後に `true` を置くと、どの条件にも当てはまらない場合を処理できます。",
          detail: "これがないと条件不一致でエラーになるため、基本的に最後へ置くのが安全です。",
          example: "true -> :unknown"
        }
      ],
      walkthrough: [
        "`cond do` は条件式を上から順番に評価し、最初に真になった分岐を実行します。",
        "`n < 0 -> :negative` のように、条件と戻り値を `->` で結びます。",
        "`true -> ...` を最後に置くとデフォルト分岐として機能します。"
      ],
      snippet: """
      cond do
        n < 0 -> :negative
        n == 0 -> :zero
        true -> :positive
      end
      """
    },
    %{
      id: "04-pipe-and-enum",
      step: 4,
      title: "パイプ演算子と Enum",
      summary: "データ変換を左から右へ読みやすく書く `|>` を練習します。",
      goals: [
        "パイプで処理の流れを読みやすくする",
        "Enum.map/filter/sum を組み合わせる",
        "関数の第一引数に値が渡ることを理解する"
      ],
      concepts: [
        %{
          term: "パイプ演算子 (`|>`)",
          concept: "左の値を右の関数の第一引数へ渡します。",
          detail: "処理の順番を上から下へ読めるため、ネストより理解しやすくなります。",
          example: "[1, 2, 3] |> Enum.sum()"
        },
        %{
          term: "`Enum.map/2`",
          concept: "各要素を変換して新しいリストを返します。",
          detail: "元のリストは変更されません。Elixir の不変性と相性が良い基本関数です。",
          example: "[1, 2, 3] |> Enum.map(&(&1 * 2))"
        },
        %{
          term: "`Enum.filter/2`",
          concept: "条件に合う要素だけ残します。",
          detail: "true を返した要素だけが結果に入ります。",
          example: "[2, 4, 6] |> Enum.filter(&(rem(&1, 3) != 0))"
        }
      ],
      walkthrough: [
        "最初のリスト `[1, 2, 3, 4]` が次の関数の第一引数へ順に渡されます。",
        "`Enum.map/2` で2倍した後、`Enum.filter/2` で3の倍数を除外しています。",
        "最後の `Enum.sum/1` が残った値を合計し、最終結果 `14` を返します。"
      ],
      snippet: """
      [1, 2, 3, 4]
      |> Enum.map(&(&1 * 2))
      |> Enum.filter(&(rem(&1, 3) != 0))
      |> Enum.sum()
      # => 14
      """
    },
    %{
      id: "05-functions-and-modules",
      step: 5,
      title: "関数とモジュール",
      summary: "名前付き関数、複数句、ガードの書き方を確認します。",
      goals: [
        "モジュール内で関数を定義する",
        "関数の複数句で分岐する",
        "ガードで入力条件を表現する"
      ],
      concepts: [
        %{
          term: "モジュール (`defmodule`)",
          concept: "関連する関数をまとめる名前空間です。",
          detail: "ファイルや機能を整理し、`MyModule.func()` の形で呼び出します。",
          example: "defmodule Math do\nend"
        },
        %{
          term: "関数句 (multiple clauses)",
          concept: "同じ関数名・引数数で複数定義し、条件に応じて使い分けます。",
          detail: "上から順にマッチする句が選ばれます。",
          example: "def double(n) when is_integer(n), do: n * 2\ndef double(_), do: :error"
        },
        %{
          term: "ガード (`when`)",
          concept: "関数やパターンに追加条件を付ける仕組みです。",
          detail: "型や範囲を明示して、想定外入力を早期に分岐できます。",
          example: "when is_integer(n)"
        }
      ],
      walkthrough: [
        "`defmodule Math do ... end` で名前空間を作り、その中に `double/1` を定義します。",
        "`when is_integer(n)` はガードで、整数入力のときだけ最初の定義が使われます。",
        "`Math.double(10)` の呼び出しで条件に合う関数句が選ばれ、`20` が返ります。"
      ],
      snippet: """
      defmodule Math do
        def double(n) when is_integer(n), do: n * 2
        def double(_), do: :error
      end

      Math.double(10)
      # => 20
      """
    },
    %{
      id: "06-recursion-and-lists",
      step: 6,
      title: "再帰とリスト処理",
      summary: "ループの代わりに再帰を使う Elixir らしい書き方を学びます。",
      goals: [
        "リストの先頭と残りを分解する",
        "終了条件と再帰呼び出しを設計する",
        "Enum と再帰の使い分けを理解する"
      ],
      concepts: [
        %{
          term: "再帰",
          concept: "関数が自分自身を呼び出して問題を小さく解く方法です。",
          detail: "Elixir ではループの代わりに再帰を使うことがあります。",
          example: "def sum([head | tail]), do: head + sum(tail)"
        },
        %{
          term: "終了条件 (base case)",
          concept: "再帰を止める条件です。",
          detail: "終了条件がないと無限再帰になります。",
          example: "def sum([]), do: 0"
        },
        %{
          term: "リスト分解 (`[head | tail]`)",
          concept: "先頭要素と残りのリストに分けるパターンです。",
          detail: "head は1要素、tail は残りすべてのリストになります。",
          example: "[h | t] = [10, 20, 30]"
        }
      ],
      walkthrough: [
        "`def sum([]), do: 0` は空リストになったときの終了条件です。",
        "`[head | tail]` でリストを先頭要素と残りに分解できます。",
        "`head + sum(tail)` で小さい問題に分解しながら最終合計を組み立てます。"
      ],
      snippet: """
      def sum([]), do: 0
      def sum([head | tail]), do: head + sum(tail)
      """
    }
  ]

  def lessons, do: @lessons
  def syntax_lessons, do: @syntax_lessons

  def syntax_topics do
    Enum.map(@syntax_lessons, fn lesson ->
      %{
        id: lesson.id,
        title: lesson.title,
        description: lesson.summary,
        snippet: lesson.snippet
      }
    end)
  end

  def syntax_lesson(id) do
    Enum.find(@syntax_lessons, &(&1.id == id))
  end

  def syntax_neighbors(id) do
    case Enum.find_index(@syntax_lessons, &(&1.id == id)) do
      nil ->
        {nil, nil}

      index ->
        previous = if index > 0, do: Enum.at(@syntax_lessons, index - 1)
        next = if index < length(@syntax_lessons) - 1, do: Enum.at(@syntax_lessons, index + 1)
        {previous, next}
    end
  end

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

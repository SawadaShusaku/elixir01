# Myapp

## Learning mode (Elixir + Phoenix)

このプロジェクトには、Elixir 学習用のページを追加しています。

- 学習ページ: `http://localhost:4000/learn`
- LiveView 学習ページ: `http://localhost:4000/learn/live`
- 文法コース一覧: `http://localhost:4000/learn/syntax`
- 実装モジュール: `lib/myapp/learning.ex`
- テンプレート: `lib/myapp_web/controllers/page_html/learn.html.heex`
- LiveView: `lib/myapp_web/live/learn_live.ex`

### 学べる内容

- Pattern Matching
- Pipe Operator (`|>`)
- Immutability
- フォーム送信で試せるパイプライン演習
- LiveView でリアルタイム更新される演習（`phx-change` / `phx-submit`）
- 順番に進める基本文法コース（Step 1 〜 Step 6）

### 学習ページを拡張するには

1. `Myapp.Learning.lessons/0` に教材を追加する
2. `Myapp.Learning.sample_results/0` に実行例を追加する
3. `learn.html.heex` に表示カードを追加する
4. 必要に応じてテストを `test/myapp/learning_test.exs` に追加する

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

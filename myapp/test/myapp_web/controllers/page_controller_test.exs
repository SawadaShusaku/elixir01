defmodule MyappWeb.PageControllerTest do
  use MyappWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
  end

  test "GET /learn", %{conn: conn} do
    conn = get(conn, ~p"/learn")
    body = html_response(conn, 200)

    assert body =~ "手を動かして学ぶ Elixir + Phoenix"
    assert body =~ "演習: パイプラインを試す"
    assert body =~ "LiveView 版へ"
    assert body =~ "文法コース一覧へ"
  end

  test "GET /learn/syntax", %{conn: conn} do
    conn = get(conn, ~p"/learn/syntax")
    body = html_response(conn, 200)

    assert body =~ "Elixir 基本文法コース"
    assert body =~ "Step 1/6"
  end

  test "GET /learn/syntax/:id", %{conn: conn} do
    conn = get(conn, ~p"/learn/syntax/01-values-and-types")
    body = html_response(conn, 200)

    assert body =~ "値と型の基本"
    assert body =~ "Step 1/6"
    assert body =~ "用語と概念"
    assert body =~ "アトム (`:ok`)"
  end

  test "GET /learn/syntax/:id redirects when unknown", %{conn: conn} do
    conn = get(conn, ~p"/learn/syntax/not-found")

    assert redirected_to(conn) == ~p"/learn/syntax"
  end

  test "POST /learn/pipeline success", %{conn: conn} do
    conn = post(conn, ~p"/learn/pipeline", %{"exercise" => %{"numbers" => "2, 4, 6"}})
    body = html_response(conn, 200)

    assert body =~ "実行成功"
    assert body =~ "合計: 24"
  end

  test "POST /learn/pipeline invalid input", %{conn: conn} do
    conn = post(conn, ~p"/learn/pipeline", %{"exercise" => %{"numbers" => "2, x"}})
    body = html_response(conn, 200)

    assert body =~ "入力エラー"
    assert body =~ "整数のみ入力できます"
  end
end

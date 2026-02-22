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

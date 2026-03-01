defmodule MyappWeb.LearnLiveTest do
  use MyappWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders live learning page", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/learn/live")
    assert html =~ "LiveView 学習ラボ"
    assert html =~ "リアルタイム演習: パイプライン"
    assert html =~ "文法コース一覧へ"
  end

  test "updates pipeline result via phx-change", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/learn/live")

    html =
      view
      |> form("#live-pipeline-form", live_exercise: %{numbers: "1, 2, 3"})
      |> render_change()

    assert html =~ "実行成功"
    assert html =~ "合計: 12"
  end

  test "updates case result via select change", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/learn/live")

    html =
      view
      |> form("#live-case-form", case_exercise: %{status: "error"})
      |> render_change()

    assert html =~ "失敗パターン"
  end
end

defmodule MyappWeb.PageController do
  use MyappWeb, :controller

  alias Myapp.Learning

  def home(conn, _params) do
    render(conn, :home)
  end

  def learn(conn, _params) do
    render(conn, :learn,
      lessons: Learning.lessons(),
      examples: Learning.sample_results(),
      form: Phoenix.Component.to_form(%{"numbers" => ""}, as: :exercise),
      result: nil
    )
  end

  def run_pipeline(conn, %{"exercise" => %{"numbers" => raw_numbers}}) do
    result =
      case Learning.evaluate_pipeline(raw_numbers) do
        {:ok, data} -> {:ok, data}
        {:error, message} -> {:error, message}
      end

    render(conn, :learn,
      lessons: Learning.lessons(),
      examples: Learning.sample_results(),
      form: Phoenix.Component.to_form(%{"numbers" => raw_numbers}, as: :exercise),
      result: result
    )
  end

  def run_pipeline(conn, _params) do
    render(conn, :learn,
      lessons: Learning.lessons(),
      examples: Learning.sample_results(),
      form: Phoenix.Component.to_form(%{"numbers" => ""}, as: :exercise),
      result: {:error, "入力欄に数値を入れて送信してください。"}
    )
  end

  def syntax_index(conn, _params) do
    lessons = Learning.syntax_lessons()

    render(conn, :syntax_index,
      lessons: lessons,
      total_lessons: length(lessons)
    )
  end

  def syntax_show(conn, %{"id" => id}) do
    case Learning.syntax_lesson(id) do
      nil ->
        conn
        |> put_flash(:error, "指定したレッスンは見つかりませんでした。")
        |> redirect(to: ~p"/learn/syntax")

      lesson ->
        {previous_lesson, next_lesson} = Learning.syntax_neighbors(id)

        render(conn, :syntax_show,
          lesson: lesson,
          previous_lesson: previous_lesson,
          next_lesson: next_lesson,
          total_lessons: length(Learning.syntax_lessons())
        )
    end
  end
end

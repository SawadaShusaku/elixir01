defmodule MyappWeb.LearnLive do
  use MyappWeb, :live_view

  alias Myapp.Learning

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Live Learning")
     |> assign(:lessons, Learning.lessons())
     |> assign(:syntax_topics, Learning.syntax_topics())
     |> assign(:examples, Learning.sample_results())
     |> assign(:pipeline_result, nil)
     |> assign(:case_result, "まだ実行していません")
     |> assign(:live_form, to_form(%{"numbers" => ""}, as: :live_exercise))
     |> assign(:case_form, to_form(%{"status" => "ok"}, as: :case_exercise))}
  end

  @impl true
  def handle_event("validate_pipeline", %{"live_exercise" => %{"numbers" => numbers}}, socket) do
    result =
      if String.trim(numbers) == "" do
        nil
      else
        normalize_pipeline_result(Learning.evaluate_pipeline(numbers))
      end

    {:noreply,
     assign(socket,
       live_form: to_form(%{"numbers" => numbers}, as: :live_exercise),
       pipeline_result: result
     )}
  end

  def handle_event("run_pipeline", %{"live_exercise" => %{"numbers" => numbers}}, socket) do
    {:noreply,
     assign(socket,
       live_form: to_form(%{"numbers" => numbers}, as: :live_exercise),
       pipeline_result: normalize_pipeline_result(Learning.evaluate_pipeline(numbers))
     )}
  end

  def handle_event("run_case", %{"case_exercise" => %{"status" => status}}, socket) do
    message =
      case status do
        "ok" -> "case : 成功パターン（{:ok, value}）を処理しました。"
        "error" -> "case : 失敗パターン（{:error, reason}）を処理しました。"
        _ -> "case : 未知の値です。"
      end

    {:noreply,
     assign(socket,
       case_form: to_form(%{"status" => status}, as: :case_exercise),
       case_result: message
     )}
  end

  defp normalize_pipeline_result({:ok, data}), do: {:ok, data}
  defp normalize_pipeline_result({:error, message}), do: {:error, message}
end

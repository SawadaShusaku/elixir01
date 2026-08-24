defmodule MyappWeb.LearnLive do
  use MyappWeb, :live_view

  alias Myapp.Learning

  @impl true
  def mount(_params, _session, socket) do
    case socket.assigns.live_action do
      :dynamic ->
        socket = dynamic_socket_assign(socket)
        send(self(), :start_auto_update)
        {:ok, socket}

      _ ->
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
  end

  @impl true
  def handle_info(:start_auto_update, socket) do
    {:noreply, schedule_tick(socket)}
  end

  @impl true
  def handle_info(:tick, socket) do
    if socket.assigns.remaining <= 1 do
      now = DateTime.utc_now()
      new_number = :rand.uniform(1000)
      new_color = random_color()
      new_counter = socket.assigns.counter + 1

      new_history =
        socket.assigns.history
        |> Enum.take(99)
        |> List.insert_at(0, %{number: new_number, color: new_color, time: now})

      socket =
        socket
        |> assign(:random_number, new_number)
        |> assign(:random_color, new_color)
        |> assign(:counter, new_counter)
        |> assign(:last_updated, now)
        |> assign(:history, new_history)
        |> assign(:remaining, socket.assigns.interval)

      {:noreply, schedule_tick(socket)}
    else
      {:noreply,
       socket
       |> assign(:remaining, socket.assigns.remaining - 1)
       |> schedule_tick()}
    end
  end

  @impl true
  def handle_event(
        "set_interval",
        %{"interval_settings" => %{"interval" => interval_str}},
        socket
      ) do
    case Integer.parse(interval_str) do
      {interval, _} when interval >= 1 and interval <= 3600 ->
        {:noreply,
         socket
         |> assign(:interval, interval)
         |> assign(:remaining, interval)
         |> assign(:interval_form, to_form(%{"interval" => interval_str}, as: :interval_settings))}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("reset", _params, socket) do
    now = DateTime.utc_now()

    {:noreply,
     socket
     |> assign(:random_number, :rand.uniform(1000))
     |> assign(:random_color, random_color())
     |> assign(:counter, 0)
     |> assign(:last_updated, now)
     |> assign(:history, [])}
  end

  def handle_event("update_now", _params, socket) do
    now = DateTime.utc_now()
    new_number = :rand.uniform(1000)
    new_color = random_color()
    new_counter = socket.assigns.counter + 1

    new_history =
      socket.assigns.history
      |> Enum.take(99)
      |> List.insert_at(0, %{number: new_number, color: new_color, time: now})

    {:noreply,
     socket
     |> assign(:random_number, new_number)
     |> assign(:random_color, new_color)
     |> assign(:counter, new_counter)
     |> assign(:last_updated, now)
     |> assign(:history, new_history)}
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

  defp schedule_tick(socket) do
    Process.send_after(self(), :tick, 1000)
    socket
  end

  defp dynamic_socket_assign(socket) do
    now = DateTime.utc_now()
    interval = 5

    socket
    |> assign(:page_title, "Dynamic Dashboard")
    |> assign(:random_number, :rand.uniform(1000))
    |> assign(:random_color, random_color())
    |> assign(:counter, 0)
    |> assign(:last_updated, now)
    |> assign(:history, [])
    |> assign(:is_running, true)
    |> assign(:interval, interval)
    |> assign(:remaining, interval)
    |> assign(:interval_form, to_form(%{"interval" => "#{interval}"}, as: :interval_settings))
  end

  defp random_color do
    colors = [
      "#FF6B6B",
      "#4ECDC4",
      "#45B7D1",
      "#96CEB4",
      "#FFEAA7",
      "#DDA0DD",
      "#98D8C8",
      "#FF8C42",
      "#6A5ACD",
      "#FF69B4",
      "#32CD32",
      "#FFD700",
      "#8A2BE2",
      "#FF4500",
      "#20B2AA",
      "#FF1493",
      "#00FA9A",
      "#FFD700",
      "#8B4513",
      "#00CED1",
      "#9932CC",
      "#FF6347",
      "#00FF7F",
      "#FF8C00"
    ]

    Enum.random(colors)
  end

  defp format_remaining(seconds) when seconds >= 60 do
    mins = div(seconds, 60)
    secs = rem(seconds, 60)
    "#{mins}分#{secs}秒"
  end

  defp format_remaining(seconds) do
    "#{seconds}秒"
  end

  defp normalize_pipeline_result({:ok, data}), do: {:ok, data}
  defp normalize_pipeline_result({:error, message}), do: {:error, message}
end

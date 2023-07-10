defmodule SagaWebWeb.LightLive do
  use SagaWebWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <div class="meter">
      <span style={"width: #{@brightness}%"}>
        <%= @brightness %>%
      </span>
    </div>

    <button phx-click="off">
      Off
    </button>

    <button phx-click="down">
      Down
    </button>

    <button phx-click="up">
      Up
    </button>

    <button phx-click="on">
      On
    </button>
    """
  end

  def handle_event("on", _, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    new_brightness = socket.assigns.brightness + 10
    socket = assign(socket, :brightness, new_brightness)
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    new_brightness = socket.assigns.brightness - 10
    socket = assign(socket, :brightness, new_brightness)
    {:noreply, socket}
  end
end

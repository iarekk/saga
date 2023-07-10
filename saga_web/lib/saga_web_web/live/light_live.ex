defmodule SagaWebWeb.LightLive do
  use SagaWebWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Porch Light</h1>
    <%= @brightness %>%
    """
  end
end

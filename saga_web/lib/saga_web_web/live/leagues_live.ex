defmodule SagaWebWeb.LeaguesLive do
  require Logger
  use SagaWebWeb, :live_view

  def mount(_params, _session, socket) do
    all_leagues = Saga.Core.MockProvider.league_list()

    {:ok, socket |> assign(:leagues, all_leagues)}
  end

  def render(assigns) do
    ~H"""
    <div class="leagues-list-container">
      <h1>League list:</h1>

      <ol>
        <%= for {id, name} <- @leagues do %>
          <li>
            <%= name %>
            <.link href={"/league/?league_id=#{id}"}>link</.link>
          </li>
        <% end %>
      </ol>
    </div>
    """
  end
end

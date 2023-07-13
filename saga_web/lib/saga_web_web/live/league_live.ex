defmodule SagaWebWeb.LeagueLive do
  use SagaWebWeb, :live_view
  alias Saga.Core.GameResult

  def mount(_params, _session, socket) do
    {:ok, socket |> add_league()}
  end

  def render(assigns) do
    ~H"""
    <div class="league-container">
      <h1>League: <%= @league_name %></h1>
      <h2>Description: <%= @league_description %></h2>
      <h3>Admin: <%= @admin_name %></h3>

      <hr /> Games played:<br />
      <div class="games-grid">
        <%= for game <- @games do %>
          <div class={"player1 #{game.player1_outcome}"}>
            <%= game.player1.name %>
          </div>
          <div class={"player2 #{game.player2_outcome}"}>
            <%= game.player2.name %>
          </div>
          <div class="game-time">on: <%= game.date %></div>
        <% end %>
      </div>
    </div>
    """
  end

  def add_league(socket) do
    league = Saga.Core.MockProvider.sample_league()

    socket
    |> assign(:league_name, league.name)
    |> assign(:league_description, league.description)
    |> assign(:admin_name, league.admin.name)
    |> assign(:games, prep_results(league.results))
  end

  def prep_results(results) do
    results
    |> Enum.sort_by(& &1.date)
    |> Enum.map(&add_player_outcomes/1)
  end

  def add_player_outcomes(game_result) do
    {player1_outcome, player2_outcome} = GameResult.player_outcomes(game_result.outcome)

    game_result
    |> Map.put(:player1_outcome, player1_outcome)
    |> Map.put(:player2_outcome, player2_outcome)
  end
end

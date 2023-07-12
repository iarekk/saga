defmodule Saga.Core.PlayerStats do
  alias Saga.Core.{GameResult, Player}
  @enforce_keys ~w[name games wins losses draws opponents]a
  defstruct ~w[name games wins losses draws opponents]a

  @type t :: %Saga.Core.PlayerStats{
          name: String.t(),
          games: non_neg_integer(),
          wins: non_neg_integer(),
          losses: non_neg_integer(),
          draws: non_neg_integer(),
          opponents: map()
        }

  def no_games(name) do
    %Saga.Core.PlayerStats{
      name: name,
      games: 0,
      wins: 0,
      losses: 0,
      draws: 0,
      opponents: %{}
    }
  end

  def compute_league_stats(game_results) when is_list(game_results) do
    List.foldl(game_results, %{}, &update_stats/2)
  end

  def update_stats(%GameResult{player1: p1, player2: p2, outcome: game_outcome}, map) do
    {player1_outcome, player2_outcome} = GameResult.player_outcomes(game_outcome)

    map
    |> Map.update(
      p1.id,
      first_game(p1.name, player1_outcome, p2),
      &add_game_result(&1, player1_outcome, p2)
    )
    |> Map.update(
      p2.id,
      first_game(p2.name, player2_outcome, p1),
      &add_game_result(&1, player2_outcome, p1)
    )
  end

  def add_game_result(%Saga.Core.PlayerStats{wins: n} = st, :win, opponent),
    do:
      %Saga.Core.PlayerStats{st | wins: n + 1}
      |> increment_game_count(opponent)

  def add_game_result(%Saga.Core.PlayerStats{losses: n} = st, :loss, opponent),
    do:
      %Saga.Core.PlayerStats{st | losses: n + 1}
      |> increment_game_count(opponent)

  def add_game_result(%Saga.Core.PlayerStats{draws: n} = st, :draw, opponent),
    do:
      %Saga.Core.PlayerStats{st | draws: n + 1}
      |> increment_game_count(opponent)

  def increment_game_count(%Saga.Core.PlayerStats{} = st, %Player{} = opponent) do
    st
    |> Map.put(:games, st.games + 1)
    |> add_opponent(opponent)
  end

  def add_opponent(%Saga.Core.PlayerStats{} = st, %Player{id: id, name: name}) do
    st |> Map.put(:opponents, Map.put_new(st.opponents, id, name))
  end

  def first_game(name, result, opponent),
    do: no_games(name) |> add_game_result(result, opponent)
end

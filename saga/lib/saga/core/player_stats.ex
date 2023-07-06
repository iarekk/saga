defmodule Saga.Core.PlayerStats do
  alias Saga.Core.{GameResult, Player}
  @enforce_keys ~w[name games wins losses draws opponents]a
  defstruct ~w[name games wins losses draws opponents]a

  @type player_outcome :: :win | :loss | :draw
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

  def compute_league_stats(results) do
    List.foldl(results, %{}, &compute_stats/2)
  end

  def compute_stats(
        %GameResult{player1: p1, player2: p2, result: res},
        map
      ) do
    # get each player's game outcome
    {p1_outcome, p2_outcome} = outcomes(res)

    # update the stats for player1, then player2
    map
    |> update_stats(p1, p1_outcome, p2)
    |> update_stats(p2, p2_outcome, p1)
  end

  @spec update_stats(map, Saga.Core.Player.t(), player_outcome(), Saga.Core.Player.t()) :: map
  def update_stats(map, %Player{id: id, name: name}, result, %Player{} = opponent) do
    map
    |> Map.update(
      id,
      first_game(name, result, opponent),
      &add_game_result(&1, result, opponent)
    )
  end

  def add_game_result(%Saga.Core.PlayerStats{wins: n} = st, :win, opponent),
    do: %Saga.Core.PlayerStats{st | wins: n + 1} |> increment_game_count(opponent)

  def add_game_result(%Saga.Core.PlayerStats{losses: n} = st, :loss, opponent),
    do: %Saga.Core.PlayerStats{st | losses: n + 1} |> increment_game_count(opponent)

  def add_game_result(%Saga.Core.PlayerStats{draws: n} = st, :draw, opponent),
    do: %Saga.Core.PlayerStats{st | draws: n + 1} |> increment_game_count(opponent)

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

  @spec outcomes(GameResult.game_outcome()) :: {player_outcome(), player_outcome()}
  @doc """
  Splits the game outcome into a tuple of outcomes
  for player 1 and player 2 respectively.

  ## Examples

      iex>PlayerStats.outcomes(:player1win)
      {:win, :loss}

      iex>PlayerStats.outcomes(:player2win)
      {:loss, :win}

      iex>PlayerStats.outcomes(:draw)
      {:draw, :draw}
  """
  def outcomes(:player1win), do: {:win, :loss}
  def outcomes(:player2win), do: {:loss, :win}
  def outcomes(:draw), do: {:draw, :draw}
end

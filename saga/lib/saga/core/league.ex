defmodule Saga.Core.League do
  alias Saga.Core.{GameResult, Player, Stats}
  @enforce_keys ~w[name description admin results]a
  defstruct ~w[name description admin results]a

  @type t :: %__MODULE__{
          name: String.t(),
          description: String.t(),
          admin: Player.t(),
          results: list(GameResult.t())
        }

  def new(name, description, %Player{} = admin, results)
      when is_binary(name) and
             is_binary(description) and
             is_list(results) do
    %__MODULE__{
      name: name,
      description: description,
      admin: admin,
      results: results
    }
  end

  def add_result(%__MODULE__{results: results} = league, %GameResult{} = new_result) do
    %__MODULE__{league | results: [new_result | results]}
  end

  def update_admin(%__MODULE__{} = league, %Player{} = new_admin) do
    %__MODULE__{league | admin: new_admin}
  end

  def stats(%__MODULE__{results: results}) do
    # Player # 1 Name: X Games: A | Wins: B | Losses: C | Draws: D | Opponents: E
    # Player # 2 Name: Y Games: F | Wins: G | Losses: H | Draws: I | Opponents: K
    players = results |> get_unique_players()
    %{unique_players: players}
  end

  def get_unique_players(results) when is_list(results) do
    results |> get_unique_players_recursive(%{})
  end

  def get_unique_players_recursive([%GameResult{player1: p1, player2: p2} | tail], map) do
    new_map =
      map
      |> Map.put_new(p1.id, p1.name)
      |> Map.put_new(p2.id, p2.name)

    get_unique_players_recursive(tail, new_map)
  end

  def get_unique_players_recursive([], map) do
    map
  end

  def get_stats_recursive(
        [%GameResult{player1: p1, player2: p2, result: result} | tail],
        stats_map
      ) do
    updated_map =
      stats_map
      |> update_stats(p1, outcome_player1(result))
      |> update_stats(p2, outcome_player2(result))

    get_stats_recursive(tail, updated_map)
  end

  def get_stats_recursive([], stats_map) do
    stats_map
  end

  def update_stats(map, %Player{id: id, name: name}, result) do
    map
    |> Map.update(id, first_game(name, result), fn stats -> increment_stats(stats, result) end)
  end

  def increment_stats(%Stats{wins: n} = st, :win),
    do: %Stats{st | wins: n + 1} |> increment_games

  def increment_stats(%Stats{losses: n} = st, :loss),
    do: %Stats{st | losses: n + 1} |> increment_games

  def increment_stats(%Stats{draws: n} = st, :draw),
    do: %Stats{st | draws: n + 1} |> increment_games

  def increment_games(%Stats{games: g} = st), do: %Stats{st | games: g + 1}

  def first_game(name, :win), do: Stats.first_win(name)
  def first_game(name, :loss), do: Stats.first_loss(name)
  def first_game(name, :draw), do: Stats.first_draw(name)

  def outcome_player1(:player1win), do: :win
  def outcome_player1(:player2win), do: :loss
  def outcome_player1(:draw), do: :draw
  def outcome_player2(:player1win), do: :loss
  def outcome_player2(:player2win), do: :win
  def outcome_player2(:draw), do: :draw
end

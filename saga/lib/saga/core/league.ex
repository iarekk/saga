defmodule Saga.Core.League do
  alias Saga.Core.{GameResult, Player}
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
end

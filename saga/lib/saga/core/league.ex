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
    get_stats_recursive(results, %{})
  end

  def get_stats_recursive(
        [%GameResult{player1: p1, player2: p2, result: result} | tail],
        stats_map
      ) do
    updated_map =
      stats_map
      |> update_stats(p1, GameResult.outcome_player1(result))
      |> update_stats(p2, GameResult.outcome_player2(result))

    get_stats_recursive(tail, updated_map)
  end

  def get_stats_recursive([], stats_map) do
    stats_map
  end

  def update_stats(map, %Player{id: id, name: name}, result) do
    map
    |> Map.update(id, Stats.first_game(name, result), fn stats ->
      Stats.increment_stats(stats, result)
    end)
  end
end

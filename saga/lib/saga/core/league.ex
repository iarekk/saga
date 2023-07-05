defmodule Saga.Core.League do
  alias Saga.Core.{GameResult, Player, PlayerStats}
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
    # get_stats_recursive(results, %{})

    List.foldl(results, %{}, &fold_stats/2)
  end

  def fold_stats(
        %GameResult{} = result,
        acc
      ) do
    acc
    |> update_stats(GameResult.outcome_player1(result))
    |> update_stats(GameResult.outcome_player2(result))
  end

  def update_stats(map, {%Player{id: id, name: name}, result}) do
    map
    |> Map.update(
      id,
      PlayerStats.first_game(name, result),
      &PlayerStats.increment(&1, result)
    )
  end
end

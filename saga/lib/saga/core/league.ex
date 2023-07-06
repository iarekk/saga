defmodule Saga.Core.League do
  alias Saga.Core.{GameResult, Player, PlayerStats}
  @enforce_keys ~w[name description admin results]a
  defstruct ~w[name description admin results]a

  @type t :: %Saga.Core.League{
          name: String.t(),
          description: String.t(),
          admin: Player.t(),
          results: list(GameResult.t())
        }

  def new(name, description, %Player{} = admin, results)
      when is_binary(name) and
             is_binary(description) and
             is_list(results) do
    %Saga.Core.League{
      name: name,
      description: description,
      admin: admin,
      results: results
    }
  end

  def add_result(%Saga.Core.League{results: results} = league, %GameResult{} = new_result) do
    %Saga.Core.League{league | results: [new_result | results]}
  end

  def update_admin(%Saga.Core.League{} = league, %Player{} = new_admin) do
    %Saga.Core.League{league | admin: new_admin}
  end

  def stats(%Saga.Core.League{results: results}) do
    List.foldl(results, %{}, &compute_stats/2)
  end

  def compute_stats(
        %GameResult{player1: p1, player2: p2, result: res},
        map
      ) do
    {p1_outcome, p2_outcome} = outcomes(res)

    map
    |> update_stats(p1, p1_outcome, p2)
    |> update_stats(p2, p2_outcome, p1)
  end

  def update_stats(map, %Player{id: id, name: name}, result, %Player{} = opponent) do
    map
    |> Map.update(
      id,
      PlayerStats.first_game(name, result, opponent),
      &PlayerStats.increment(&1, result, opponent)
    )
  end

  @doc """
  Splits the game outcome into a tuple of outcomes
  for player 1 and player 2 respectively.

  ## Examples

      iex>League.outcomes(:player1win)
      {:win, :loss}

      iex>League.outcomes(:player2win)
      {:loss, :win}

      iex>League.outcomes(:draw)
      {:draw, :draw}
  """
  def outcomes(:player1win), do: {:win, :loss}
  def outcomes(:player2win), do: {:loss, :win}
  def outcomes(:draw), do: {:draw, :draw}
end

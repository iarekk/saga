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
    PlayerStats.compute_league_stats(results)
  end
end

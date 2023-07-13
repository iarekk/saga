defmodule Saga.Core.GameResult do
  alias Saga.Core.Player
  @enforce_keys ~w[date player1 player2 outcome]a
  defstruct ~w[date player1 player2 outcome]a

  @type game_outcome :: :player1win | :player2win | :draw
  @type player_outcome :: :win | :loss | :draw

  @type t :: %Saga.Core.GameResult{
          date: DateTime.t(),
          player1: Player.t(),
          player2: Player.t(),
          outcome: game_outcome()
        }

  def player1_won(%DateTime{} = date, %Player{} = player1, %Player{} = player2) do
    new(date, player1, player2, :player1win)
  end

  def player2_won(%DateTime{} = date, %Player{} = player1, %Player{} = player2) do
    new(date, player1, player2, :player2win)
  end

  def draw(%DateTime{} = date, %Player{} = player1, %Player{} = player2) do
    new(date, player1, player2, :draw)
  end

  @spec new(DateTime.t(), Saga.Core.Player.t(), Saga.Core.Player.t(), game_outcome()) ::
          Saga.Core.GameResult.t()
  def new(%DateTime{} = date, %Player{} = player1, %Player{} = player2, outcome)
      when is_atom(outcome) do
    if(player1.id == player2.id, do: raise("player1 and player2 can't be same"))

    %Saga.Core.GameResult{
      date: date |> DateTime.truncate(:second),
      player1: player1,
      player2: player2,
      outcome: outcome
    }
  end

  @spec player_outcomes(game_outcome()) :: {player_outcome(), player_outcome()}
  @doc """
  Splits the game outcome into a tuple of outcomes
  for player 1 and player 2 respectively.

  ## Examples

      iex>PlayerStats.player_outcomes(:player1win)
      {:win, :loss}

      iex>PlayerStats.player_outcomes(:player2win)
      {:loss, :win}

      iex>PlayerStats.player_outcomes(:draw)
      {:draw, :draw}
  """
  def player_outcomes(:player1win), do: {:win, :loss}
  def player_outcomes(:player2win), do: {:loss, :win}
  def player_outcomes(:draw), do: {:draw, :draw}
end

defmodule Saga.Core.GameResult do
  alias Saga.Core.Player
  @enforce_keys ~w[date player1 player2 result]a
  defstruct ~w[date player1 player2 result]a

  @type outcome :: :player1win | :player2win | :draw

  @type outcome_for_player :: :win | :loss | :draw
  @type t :: %__MODULE__{
          date: DateTime.t(),
          player1: Player.t(),
          player2: Player.t(),
          result: outcome()
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

  @spec new(DateTime.t(), Saga.Core.Player.t(), Saga.Core.Player.t(), outcome()) ::
          Saga.Core.GameResult.t()
  defp new(%DateTime{} = date, %Player{} = player1, %Player{} = player2, result)
       when is_atom(result) do
    %__MODULE__{
      date: date,
      player1: player1,
      player2: player2,
      result: result
    }
  end

  def outcome_player1(:player1win), do: :win
  def outcome_player1(:player2win), do: :loss
  def outcome_player1(:draw), do: :draw
  def outcome_player2(:player1win), do: :loss
  def outcome_player2(:player2win), do: :win
  def outcome_player2(:draw), do: :draw
end

defmodule Saga.Core.GameResult do
  alias Saga.Core.Player
  @enforce_keys ~w[date player1 player2 result]a
  defstruct ~w[date player1 player2 result]a

  @type game_outcome :: :player1win | :player2win | :draw

  @type outcome_for_player :: :win | :loss | :draw
  @type t :: %__MODULE__{
          date: DateTime.t(),
          player1: Player.t(),
          player2: Player.t(),
          result: game_outcome()
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

  defp new(%DateTime{} = date, %Player{} = player1, %Player{} = player2, outcome)
       when is_atom(outcome) do
    %__MODULE__{
      date: date,
      player1: player1,
      player2: player2,
      result: outcome
    }
  end

  def outcome_player1(%__MODULE__{player1: p1, result: :player1win}), do: {p1, :win}
  def outcome_player1(%__MODULE__{player1: p1, result: :player2win}), do: {p1, :loss}
  def outcome_player1(%__MODULE__{player1: p1, result: :draw}), do: {p1, :draw}

  def outcome_player2(%__MODULE__{player2: p2, result: :player1win}), do: {p2, :loss}
  def outcome_player2(%__MODULE__{player2: p2, result: :player2win}), do: {p2, :win}
  def outcome_player2(%__MODULE__{player2: p2, result: :draw}), do: {p2, :draw}
end

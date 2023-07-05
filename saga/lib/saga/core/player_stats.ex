defmodule Saga.Core.PlayerStats do
  alias Saga.Core.Player
  @enforce_keys ~w[name games wins losses draws opponents]a
  defstruct ~w[name games wins losses draws opponents]a

  @type t :: %__MODULE__{
          name: String.t(),
          games: non_neg_integer(),
          wins: non_neg_integer(),
          losses: non_neg_integer(),
          draws: non_neg_integer(),
          opponents: map()
        }

  def no_games(name) do
    %__MODULE__{
      name: name,
      games: 0,
      wins: 0,
      losses: 0,
      draws: 0,
      opponents: %{}
    }
  end

  def increment(%__MODULE__{wins: n} = st, :win, opponent),
    do: %__MODULE__{st | wins: n + 1} |> increment_games(opponent)

  def increment(%__MODULE__{losses: n} = st, :loss, opponent),
    do: %__MODULE__{st | losses: n + 1} |> increment_games(opponent)

  def increment(%__MODULE__{draws: n} = st, :draw, opponent),
    do: %__MODULE__{st | draws: n + 1} |> increment_games(opponent)

  def increment_games(%__MODULE__{} = st, %Player{id: id, name: name}) do
    st
    |> Map.put(:games, st.games + 1)
    |> Map.put(:opponents, Map.put_new(st.opponents, id, name))
  end

  def first_game(name, result, opponent), do: no_games(name) |> increment(result, opponent)
end

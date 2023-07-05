defmodule Saga.Core.PlayerStats do
  @enforce_keys ~w[name games wins losses draws]a
  defstruct ~w[name games wins losses draws]a

  @type t :: %__MODULE__{
          name: String.t(),
          games: non_neg_integer(),
          wins: non_neg_integer(),
          losses: non_neg_integer(),
          draws: non_neg_integer()
        }

  def no_games(name) do
    %__MODULE__{
      name: name,
      games: 0,
      wins: 0,
      losses: 0,
      draws: 0
    }
  end

  def increment(%__MODULE__{wins: n} = st, :win),
    do: %__MODULE__{st | wins: n + 1} |> increment_games

  def increment(%__MODULE__{losses: n} = st, :loss),
    do: %__MODULE__{st | losses: n + 1} |> increment_games

  def increment(%__MODULE__{draws: n} = st, :draw),
    do: %__MODULE__{st | draws: n + 1} |> increment_games

  def increment_games(%__MODULE__{} = st), do: Map.put(st, :games, st.games + 1)

  def first_game(name, result), do: no_games(name) |> increment(result)
end

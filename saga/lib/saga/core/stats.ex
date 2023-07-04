defmodule Saga.Core.Stats do
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

  def increment_stats(%__MODULE__{wins: n} = st, :win),
    do: %__MODULE__{st | wins: n + 1} |> increment_games

  def increment_stats(%__MODULE__{losses: n} = st, :loss),
    do: %__MODULE__{st | losses: n + 1} |> increment_games

  def increment_stats(%__MODULE__{draws: n} = st, :draw),
    do: %__MODULE__{st | draws: n + 1} |> increment_games

  def increment_games(%__MODULE__{games: g} = st), do: %__MODULE__{st | games: g + 1}

  def first_game(name, res), do: no_games(name) |> increment_stats(res)
end

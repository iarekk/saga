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

  def first_win(name) do
    %__MODULE__{
      name: name,
      games: 1,
      wins: 1,
      losses: 0,
      draws: 0
    }
  end

  def first_loss(name) do
    %__MODULE__{
      name: name,
      games: 1,
      wins: 0,
      losses: 1,
      draws: 0
    }
  end

  def first_draw(name) do
    %__MODULE__{
      name: name,
      games: 1,
      wins: 0,
      losses: 0,
      draws: 1
    }
  end
end

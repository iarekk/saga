defmodule Saga.Core.Player do
  @enforce_keys ~w[id name]a
  defstruct ~w[id name]a

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t()
        }

  def create_player(id, name) when is_integer(id) and is_binary(name) do
    %__MODULE__{id: id, name: name}
  end
end

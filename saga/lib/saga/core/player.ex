defmodule Saga.Core.Player do
  @enforce_keys ~w[id name]a
  defstruct ~w[id name]a

  @type t :: %Saga.Core.Player{
          id: integer(),
          name: String.t()
        }

  def create_player(id, name) when is_integer(id) and is_binary(name) do
    %Saga.Core.Player{id: id, name: name}
  end
end

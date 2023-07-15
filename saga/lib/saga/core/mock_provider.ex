defmodule Saga.Core.MockProvider do
  alias Saga.Core.{GameResult, League, Player}

  def league(1), do: sample_league()
  def league(2), do: second_sample_league()

  def league_list(), do: %{1 => "Chess newbies", 2 => "Chess masters"}

  def sample_league() do
    player_dave = Player.create_player(1, "Dave")
    player_lisa = Player.create_player(2, "Lisa")
    player_janet = Player.create_player(3, "Janet")

    now = DateTime.utc_now()

    result1 =
      GameResult.player2_won(
        now |> DateTime.add(-5, :day),
        player_dave,
        player_lisa
      )

    result2 =
      GameResult.draw(
        now |> DateTime.add(-3, :day),
        player_dave,
        player_janet
      )

    result3 =
      GameResult.player1_won(
        now |> DateTime.add(-2, :day),
        player_lisa,
        player_janet
      )

    result4 =
      GameResult.player2_won(
        DateTime.utc_now(),
        player_lisa,
        player_janet
      )

    league =
      League.new("Chess newbies", "Players with ELO < 9000", player_lisa, [
        result1,
        result2,
        result3,
        result4
      ])

    league
  end

  def second_sample_league() do
    player_alice = Player.create_player(10, "Alice")
    player_bob = Player.create_player(20, "Bob")
    player_carol = Player.create_player(30, "Carol")

    now = DateTime.utc_now()

    result1 =
      GameResult.player2_won(
        now |> DateTime.add(-50, :day),
        player_alice,
        player_carol
      )

    result2 =
      GameResult.draw(
        now |> DateTime.add(-30, :day),
        player_alice,
        player_bob
      )

    result3 =
      GameResult.player1_won(
        now |> DateTime.add(-20, :day),
        player_carol,
        player_alice
      )

    result4 =
      GameResult.player2_won(
        now,
        player_carol,
        player_bob
      )

    league =
      League.new("Chess masters", "Google en passant", player_alice, [
        result1,
        result2,
        result3,
        result4
      ])

    league
  end
end

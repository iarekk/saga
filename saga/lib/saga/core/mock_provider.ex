defmodule Saga.Core.MockProvider do
  alias Saga.Core.{GameResult, League, Player}

  def sample_league() do
    player_dave = Player.create_player(1, "Dave")
    player_lisa = Player.create_player(2, "Lisa")
    player_janet = Player.create_player(3, "Janet")

    now = DateTime.utc_now()

    result1 =
      GameResult.player2_won(
        # TODO fix the datetime creation later
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
end

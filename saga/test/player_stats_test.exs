defmodule PlayerStatsTest do
  alias Saga.Core.{GameResult, Player, PlayerStats}
  use ExUnit.Case
  doctest PlayerStats

  test "stats are computed correctly" do
    player_dave = Player.create_player(1, "Dave")
    player_lisa = Player.create_player(2, "Lisa")
    player_janet = Player.create_player(3, "Janet")

    result1 = GameResult.player2_won(DateTime.utc_now(), player_dave, player_lisa)
    result2 = GameResult.draw(DateTime.utc_now(), player_dave, player_janet)
    result3 = GameResult.player1_won(DateTime.utc_now(), player_lisa, player_janet)
    result4 = GameResult.player2_won(DateTime.utc_now(), player_lisa, player_janet)

    stats =
      PlayerStats.compute_league_stats([result1, result2, result3, result4])

    assert Map.has_key?(stats, player_dave.id), "Dave has stats"
    assert Map.has_key?(stats, player_lisa.id), "Lisa has stats"
    assert Map.has_key?(stats, player_janet.id), "Janet has stats"
    assert 3 == stats |> Map.keys() |> Enum.count(), "Stats should have 3 players"

    assert stats[1] == %PlayerStats{
             name: "Dave",
             games: 2,
             wins: 0,
             losses: 1,
             draws: 1,
             opponents: %{
               2 => "Lisa",
               3 => "Janet"
             }
           }

    assert stats[2] == %PlayerStats{
             name: "Lisa",
             games: 3,
             wins: 2,
             losses: 1,
             draws: 0,
             opponents: %{1 => "Dave", 3 => "Janet"}
           }

    assert stats[3] == %PlayerStats{
             name: "Janet",
             games: 3,
             wins: 1,
             losses: 1,
             draws: 1,
             opponents: %{1 => "Dave", 2 => "Lisa"}
           }
  end
end

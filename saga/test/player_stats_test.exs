defmodule PlayerStatsTest do
  alias Saga.Core.{GameResult, Player, PlayerStats}
  use ExUnit.Case
  doctest PlayerStats

  test "stats are computed correctly" do
    player_dave = Player.create_player(1, "Dave")
    player_lisa = Player.create_player(2, "Lisa")
    player_janet = Player.create_player(3, "Janet")
    player_sam = Player.create_player(4, "Sam")

    result1 = GameResult.player2_won(DateTime.utc_now(), player_dave, player_lisa)
    result2 = GameResult.draw(DateTime.utc_now(), player_dave, player_janet)
    result3 = GameResult.player1_won(DateTime.utc_now(), player_lisa, player_janet)
    result4 = GameResult.player2_won(DateTime.utc_now(), player_lisa, player_janet)
    result5 = GameResult.player1_won(DateTime.utc_now(), player_dave, player_sam)

    stats =
      PlayerStats.compute_league_stats([result1, result2, result3, result4, result5])

    assert Map.has_key?(stats, player_dave.id), "Dave has stats"
    assert Map.has_key?(stats, player_lisa.id), "Lisa has stats"
    assert Map.has_key?(stats, player_janet.id), "Janet has stats"
    assert Map.has_key?(stats, player_sam.id), "Sam has stats"
    assert 4 == stats |> Map.keys() |> Enum.count(), "Stats should have 3 players"

    assert stats[1] == %PlayerStats{
             name: "Dave",
             games: 3,
             wins: 1,
             losses: 1,
             draws: 1,
             opponents: %{
               2 => "Lisa",
               3 => "Janet",
               4 => "Sam"
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

    assert stats[4] == %PlayerStats{
             name: "Sam",
             games: 1,
             wins: 0,
             losses: 1,
             draws: 0,
             opponents: %{1 => "Dave"}
           }
  end
end

defmodule LeagueTest do
  alias Saga.Core.{GameResult, League, Player, PlayerStats}
  use ExUnit.Case
  doctest League

  test "league admin can change" do
    player_dave = Player.create_player(1, "Dave")
    player_lisa = Player.create_player(2, "Lisa")

    league = League.new("Chess newbies", "Players with ELO < 9000", player_lisa, [])

    assert league.admin == player_lisa

    upd_league = league |> League.update_admin(player_dave)

    assert upd_league.admin == player_dave
  end

  test "basic league stats are computed" do
    player_dave = Player.create_player(1, "Dave")
    player_lisa = Player.create_player(2, "Lisa")
    player_janet = Player.create_player(3, "Janet")

    league = League.new("Chess newbies", "Players with ELO < 9000", player_lisa, [])

    result1 = GameResult.player2_won(DateTime.utc_now(), player_dave, player_lisa)
    result2 = GameResult.draw(DateTime.utc_now(), player_dave, player_janet)
    result3 = GameResult.player1_won(DateTime.utc_now(), player_lisa, player_janet)
    result4 = GameResult.player2_won(DateTime.utc_now(), player_lisa, player_janet)

    updated_league =
      league
      |> League.add_result(result1)
      |> League.add_result(result2)
      |> League.add_result(result3)
      |> League.add_result(result4)

    stats = League.stats(updated_league)

    assert Map.keys(stats) |> Enum.sort() == [player_dave.id, player_lisa.id, player_janet.id],
           "All players accounted for"

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

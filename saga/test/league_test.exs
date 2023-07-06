defmodule LeagueTest do
  alias Saga.Core.{GameResult, League, Player}
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

  test "league records results" do
    player_dave = Player.create_player(1, "Dave")
    player_lisa = Player.create_player(2, "Lisa")
    player_janet = Player.create_player(3, "Janet")

    result1 = GameResult.player2_won(DateTime.utc_now(), player_dave, player_lisa)
    result2 = GameResult.draw(DateTime.utc_now(), player_dave, player_janet)
    result3 = GameResult.player1_won(DateTime.utc_now(), player_lisa, player_janet)
    result4 = GameResult.player2_won(DateTime.utc_now(), player_lisa, player_janet)

    league = League.new("Chess newbies", "Players with ELO < 9000", player_lisa, [])

    updated_league =
      league
      |> League.add_result(result1)
      |> League.add_result(result2)
      |> League.add_result(result3)
      |> League.add_result(result4)

    assert updated_league.results == [result4, result3, result2, result1],
           "All game results are recorded"
  end
end

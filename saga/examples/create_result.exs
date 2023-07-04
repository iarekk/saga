# run this while in the 'saga' project root:
#
# > iex --dot-iex examples/create_result.exs -S mix
#
# it will open an iex shell with the script outcome computed, and variables available
#
# Otherwise, running the follwoing will exec the script:
#
# > mix run examples/create_result.exs

alias Saga.Core.{GameResult, Player, League}

p1 = Player.create_player(1, "Dave")

p2 = Player.create_player(2, "Lisa")

p3 = Player.create_player(3, "Janet")

league = League.new("Chess newbies", "Players with ELO < 9000", p2, [])

IO.puts("League created: #{inspect(league, pretty: true)}")

result1 = GameResult.player2_won(DateTime.utc_now(), p1, p2)
result2 = GameResult.draw(DateTime.utc_now(), p1, p3)

updated_league =
  league
  |> League.add_result(result1)
  |> League.add_result(result2)
  |> League.update_admin(p2)

IO.puts("League updated: #{inspect(updated_league, pretty: true)}")

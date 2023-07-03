# run this while in the 'saga' project root:
#
# >iex --dot-iex examples/create_result.exs -S mix
#
# it will open an iex shell with the script outcome computed, and variables available
#
# Otherwise, running the follwoing will exec the script:
#
# >mix run examples/create_result.exs

alias Saga.Core.{GameResult, Player}

p1 = Player.create_player(1, "Dave")

p2 = Player.create_player(2, "Lisa")

result = GameResult.player2_won(DateTime.utc_now(), p1, p2)

IO.puts("Result: #{inspect(result, pretty: true)}")

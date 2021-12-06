defmodule Day6 do
  def parse(input), do: input |> String.split([",", "\n"], trim: true) |> Enum.map(&String.to_integer/1)

  def simulate(timers, days) do
    frequencies = Enum.frequencies(timers)

    0..8
    |> Stream.cycle()
    |> Enum.take(days)
    |> Enum.reduce(frequencies, fn x, acc ->
      Map.get_and_update()
      existing_fish = Map.get(acc, x, 0)
      Map.update(acc, rem(x + 7, 9), existing_fish, fn count -> count + existing_fish end)
    end)
    |> Enum.map(fn {_, count} -> count end)
    |> Enum.sum()
  end
end

input = File.read!("input.txt") |> Day6.parse()

IO.puts("Part 1: #{Day6.simulate(input, 80)}")
IO.puts("Part 2: #{Day6.simulate(input, 256)}")

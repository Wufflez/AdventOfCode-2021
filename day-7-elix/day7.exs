import Enum

defmodule Day7 do
  def triangle(n), do: div(n * (n + 1), 2)

  def compute_total_fuel(positions, target, :part1),
    do: positions |> map(&abs(&1-target)) |> sum

  def compute_total_fuel(positions, target, :part2),
    do: positions |> map(&triangle(abs(&1 - target))) |> sum

  def compute_best_fuel(positions, mode) do
    min_pos = positions |> min
    max_pos = positions |> max
    min_pos..max_pos |> map(fn target -> compute_total_fuel(positions, target, mode) end) |> min
  end
end

input = File.read!("input.txt") |> String.trim()
crab_positions = input |> String.split(",") |> map(&String.to_integer/1)

IO.puts("Part 1: #{Day7.compute_best_fuel(crab_positions, :part1)}")
IO.puts("Part 2: #{Day7.compute_best_fuel(crab_positions, :part2)}")

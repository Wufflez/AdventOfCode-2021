defmodule Day1 do
  def count_increases(numbers), do: numbers |> Enum.chunk_every(2, 1, :discard) |> Enum.count(fn [a, b] -> b > a end)
  def part_one(numbers), do: numbers |> count_increases
  def part_two(numbers), do: numbers |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1) |> count_increases
end

input = File.read!("input.txt") |> String.split |> Enum.map(&String.to_integer/1)

IO.puts("Part one: #{Day1.part_one(input)}")
IO.puts("Part two: #{Day1.part_two(input)}")

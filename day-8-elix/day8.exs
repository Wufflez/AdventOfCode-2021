import Enum

defmodule Day8 do
  def parse(input), do: input |> String.split("\n") |> map(&parse_line/1)
  def parse_patterns(patterns), do: String.split(patterns) |> map(fn str -> String.to_charlist(str) |> MapSet.new end)
  def parse_line(line) do
    [left, right] = String.split(line, " | ")
    {parse_patterns(left), parse_patterns(right)}
  end

  def part_one(input) do
    input
    |> flat_map(fn {_, outputs} -> outputs end)
    |> filter(fn output -> MapSet.size(output) in [2, 3, 4, 7] end)
    |> count()
  end

  def part_two(input), do: input |> map(fn entry -> deduce_output(entry) end) |> sum()

  def deduce_output({patterns, outputs}) do
    digit_one = patterns |> find(fn p -> MapSet.size(p) == 2 end)
    digit_four = patterns |> find(fn p -> MapSet.size(p) == 4 end)
    outputs
    |> reduce(0, fn output, acc ->
      four_overlap = MapSet.intersection(output, digit_four) |> MapSet.size()
      one_overlap = MapSet.intersection(output, digit_one) |> MapSet.size()
      digit = case MapSet.size(output) do
          2 -> 1
          3 -> 7
          5 when one_overlap == 2 -> 3
          5 when four_overlap == 3 -> 5
          5 -> 2
          6 when one_overlap == 1 -> 6
          6 when four_overlap == 3 -> 0
          6 -> 9
          4 -> 4
          7 -> 8
        end
      acc * 10 + digit
    end)
  end
end

input = File.read!("input.txt") |> String.trim() |> Day8.parse()

IO.puts("Part 1: #{Day8.part_one(input)}")
IO.puts("Part 2: #{Day8.part_two(input)}")

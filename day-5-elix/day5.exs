defmodule Day5 do
  def parse(input), do: input |> String.split("\n", trim: true) |> Enum.map(&parse_line/1)

  def parse_line(line) do
    [first, "->", second] = String.split(line)
    {parse_coord(first), parse_coord(second)}
  end

  def parse_coord(coord), do: String.split(coord, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

  def line({{x1, y}, {x2, y}}), do: for(x <- x1..x2, do: {x, y})
  def line({{x, y1}, {x, y2}}), do: for(y <- y1..y2, do: {x, y})
  def line({{x1, y1}, {x2, y2}}), do: Enum.zip(x1..x2, y1..y2)

  def horizontical?({{x, _}, {x, _}}), do: true
  def horizontical?({{_, y}, {_, y}}), do: true
  def horizontical?(_), do: false

  def count_overlaps(lines) do
    lines
    |> Enum.flat_map(&Day5.line/1)
    |> Enum.reduce(%{}, fn pos, map -> Map.update(map, pos, 1, &(&1 + 1)) end)
    |> Enum.count(fn {_, count} -> count >= 2 end)
  end

  def part1(lines), do: lines |> Enum.filter(&Day5.horizontical?/1) |> count_overlaps()
  def part2(lines), do: lines |> count_overlaps()
end

lines = Day5.parse(File.read!("input.txt"))
IO.puts("Part 1: #{Day5.part1(lines)}")
IO.puts("Part 2: #{Day5.part2(lines)}")

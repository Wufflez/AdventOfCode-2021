import Enum

defmodule Day9 do
  def parse(input) do
    for {line, y} <- input |> String.split("\n") |> with_index,
        {char, x} <- line |> String.to_charlist() |> with_index do
      {{x, y}, char - ?0}
    end
  end

  def neighbours({x, y}), do: [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]

  def lower_than_neighbours?(map, pos),
    do: neighbours(pos) |> all?(fn nb -> map[nb] > map[pos] end)

  def low_points(map), do: map |> filter(fn {pos, _} -> Day9.lower_than_neighbours?(map, pos) end)

  def upslope_neighbours(map, pos),
    do: neighbours(pos) |> filter(fn np -> map[np] < 9 and map[np] > map[pos] end)

  def get_upslopes(map, positions) do
    upslope_neighbours = flat_map(positions, fn p -> upslope_neighbours(map, p) end)
    positions = MapSet.new(positions)

    case upslope_neighbours do
      [] -> positions
      neighbouring -> get_upslopes(map, neighbouring) |> MapSet.union(positions)
    end
  end

  def part_one(map), do: map |> low_points() |> map(fn {_, height} -> height + 1 end) |> sum()

  def part_two(map) do
    low_points(map)
    |> map(fn {pos, _} -> MapSet.size(get_upslopes(map, [pos])) end)
    |> sort(:desc)
    |> take(3)
    |> product()
  end
end

map = File.read!("input.txt") |> Day9.parse() |> Map.new()
IO.puts("Part 1: #{Day9.part_one(map)}")
IO.puts("Part 2: #{Day9.part_two(map)}")

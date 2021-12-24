defmodule Day13 do
  def parse(input) do
    [dots, folds] = String.split(input, "\n\n")
    {parse_dots(dots), parse_folds(folds)}
  end

  def parse_dot(dot) do
    [x, y] = String.split(dot, ",")
    {String.to_integer(x), String.to_integer(y)}
  end

  def parse_dots(dots), do: String.split(dots, "\n") |> Enum.map(&parse_dot/1)

  def parse_fold("fold along x=" <> x), do: {:fold_x, String.to_integer(x)}
  def parse_fold("fold along y=" <> y), do: {:fold_y, String.to_integer(y)}
  def parse_folds(folds), do: String.split(folds, "\n", trim: true) |> Enum.map(&parse_fold/1)

  def fold({x, y}, {:fold_x, fold}), do: {fold - abs(x - fold), y}
  def fold({x, y}, {:fold_y, fold}), do: {x, fold - abs(y - fold)}
  def fold(fold, dots), do: dots |> Enum.map(&Day13.fold(&1, fold)) |> Enum.uniq()
  def part_one(dots, [first_fold | _]), do: fold(first_fold, dots) |> length()

  def part_two(dots, folds) do
    folded_dots = folds |> Enum.reduce(dots, &fold/2) |> MapSet.new()

    {width, _} = folded_dots |> Enum.max_by(fn {x, _} -> x end)
    {_, height} = folded_dots |> Enum.max_by(fn {_, y} -> y end)

    for y <- 0..height,
        x <- 0..width do
      if {x, y} in folded_dots do
        IO.write("@")
      else
        IO.write(" ")
      end

      if x == width do
        IO.puts("")
      end
    end
  end
end

{dots, folds} = File.read!("input.txt") |> Day13.parse()
IO.puts("Part 1: #{Day13.part_one(dots, folds)}")
IO.puts("Part 2:")
Day13.part_two(dots, folds)

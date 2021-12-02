defmodule Day2 do
  def parse_commands(input), do:
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split/1)
      |> Enum.map(fn [direction, distance] -> {String.to_atom(direction), String.to_integer(distance)} end)

  def part_1_command(command, {position, depth}) do
    case command do
      {:forward, x} -> {position + x, depth}
      {:down, x} -> {position, depth + x}
      {:up, x} -> {position, depth - x}
    end
  end

  def part_2_command(command, {position, depth, aim}) do
    case command do
      {:forward, x} -> {position + x, depth + aim * x, aim}
      {:down, x} -> {position, depth, aim + x}
      {:up, x} -> {position, depth, aim - x}
    end
  end
end

commands = File.read!("input.txt") |> Day2.parse_commands()

{position, depth} = Enum.reduce(commands, {0, 0}, &Day2.part_1_command/2)
IO.puts("Part 1 = #{position * depth}")

{position, depth, _aim} = Enum.reduce(commands, {0, 0, 0}, &Day2.part_2_command/2)
IO.puts("Part 2 = #{position * depth}")

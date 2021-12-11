defmodule Day11 do
  def parse(input) do
    for {line, y} <- input |> String.split() |> Enum.with_index(),
        {char, x} <- line |> String.to_charlist() |> Enum.with_index() do
      {{x, y}, char - ?0}
    end
    |> Map.new()
  end

  def boost_octopus(position, world) do
    if not Map.has_key?(world, position) do
      world
    else
      updated = world |> Map.update!(position, fn power -> power + 1 end)

      if updated[position] == 10 do
        update_adjacent(updated, position)
      else
        updated
      end
    end
  end

  def adjacent_positions({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  def update_adjacent(world, origin),
    do: adjacent_positions(origin) |> Enum.reduce(world, &boost_octopus/2)

  def reset_flashed({position, power} = octopus) do
    if power > 9, do: {position, 0}, else: octopus
  end

  def just_flashed?({_position, 0}), do: true
  def just_flashed?(_), do: false

  def step(world) do
    all_positions = world |> Map.keys()

    all_positions
    |> Enum.reduce(world, &boost_octopus/2)
    |> Enum.map(&reset_flashed/1)
    |> Map.new()
  end

  def simulate(world, step_count) do
    1..step_count
    |> Enum.reduce({world, 0}, fn _step, {world, count} ->
      world = step(world)
      newly_flashed = world |> Enum.count(&just_flashed?/1)
      {world, count + newly_flashed}
    end)
  end

  def simulate_until_sync(world), do: simulate_until_sync(world, 1)

  defp simulate_until_sync(world, step) do
    world = step(world)

    if world |> Enum.all?(&just_flashed?/1) do
      step
    else
      simulate_until_sync(world, step + 1)
    end
  end
end

world = File.read!("input.txt") |> Day11.parse()

{_, flash_count} = Day11.simulate(world, 100)
IO.puts("Part 1: #{flash_count}")

step_count = Day11.simulate_until_sync(world)
IO.puts("Part 2: #{step_count}")

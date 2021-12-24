defmodule Day14 do
  def parse(input) do
    [template | rules] = String.split(input, "\n", trim: true)

    template =
      template |> String.to_charlist() |> Enum.chunk_every(2, 1, [0]) |> Enum.frequencies()

    rules = Map.new(rules, fn <<a, b, " -> ", c>> -> {[a, b], c} end)
    {template, rules}
  end

  def polymerise(template, rules, iterations) do
    {{_, mins}, {_, maxes}} =
      1..iterations
      |> Enum.reduce(template, fn _, acc ->
        Enum.reduce(acc, %{}, fn {[a, b] = pair, count}, acc ->
          case rules do
            %{^pair => o} ->
              acc
              |> Map.update([a, o], count, &(&1 + count))
              |> Map.update([o, b], count, &(&1 + count))

            %{} ->
              Map.put(acc, pair, count)
          end
        end)
      end)
      |> Enum.group_by(&hd(elem(&1, 0)), &elem(&1, 1))
      |> Enum.min_max_by(fn {_, counts} -> Enum.sum(counts) end)

    Enum.sum(maxes) - Enum.sum(mins)
  end
end

{template, rules} = File.read!("input.txt") |> Day14.parse()
IO.puts("Part 1: #{Day14.polymerise(template, rules, 10)}")
IO.puts("Part 2: #{Day14.polymerise(template, rules, 40)}")

import Enum

defmodule Day10 do
  def err_score(?)), do: 3
  def err_score(?]), do: 57
  def err_score(?}), do: 1197
  def err_score(?>), do: 25137

  def completion_score(?(), do: 1
  def completion_score(?[), do: 2
  def completion_score(?{), do: 3
  def completion_score(?<), do: 4

  def middle(list), do: at(list, div(length(list), 2))

  def total_completion_score({:incomplete, stack}),
    do: stack |> reduce(0, fn ch, score -> score * 5 + completion_score(ch) end)

  def incomplete?({:incomplete, _}), do: true
  def incomplete?(_), do: false

  def validate(chunk) do
    chunk
    |> String.to_charlist()
    |> reduce_while([], fn ch, stack ->
      case stack do
        [] ->
          {:cont, [ch]}

        [top | remaining] ->
          case ch do
            x when x in [?{, ?(, ?[, ?<] -> {:cont, [ch | stack]}
            ?] when top == ?[ -> {:cont, remaining}
            ?) when top == ?( -> {:cont, remaining}
            ?> when top == ?< -> {:cont, remaining}
            ?} when top == ?{ -> {:cont, remaining}
            illegal_char -> {:halt, {:invalid, illegal_char}}
          end
      end
    end)
    |> then(fn
      {:invalid, illegal_char} -> {:invalid, illegal_char}
      remaining -> {:incomplete, remaining}
    end)
  end

  def part_one(chunks) do
    chunks
    |> map(&validate/1)
    |> reject(&incomplete?/1)
    |> map(fn {:invalid, bad_char} -> err_score(bad_char) end)
    |> sum()
  end

  def part_two(chunks) do
    chunks
    |> map(&validate/1)
    |> filter(&incomplete?/1)
    |> map(&total_completion_score/1)
    |> sort()
    |> middle()
  end
end

chunks = File.read!("input.txt") |> String.split()

IO.puts("Part 1: #{Day10.part_one(chunks)}")
IO.puts("Part 2: #{Day10.part_two(chunks)}")

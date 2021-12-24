defmodule Day12 do

  def count_terminal(paths, revisited?) do
    traverse(paths["start"], paths, MapSet.new(), revisited?, 0)
  end

  defp traverse(["end" | caves], paths, visited, revisited?, count) do
    traverse(caves, paths, visited, revisited?, count + 1)
  end

  defp traverse([], _edges, _seen, _revisited?, count), do: count

  defp traverse([cave | caves], paths, visited, revisited?, count) do
    count =
      cond do
        cave == "start" or (revisited? and cave in visited) ->  count

        cave in visited ->
          traverse(paths[cave], paths, MapSet.put(visited, cave), true, count)

        small_cave?(cave) ->
          traverse(paths[cave], paths, MapSet.put(visited, cave), revisited?, count)

        true -> traverse(paths[cave], paths, visited, revisited?, count)
      end

    traverse(caves, paths, visited, revisited?, count)
  end

  defp small_cave?(cave), do: String.downcase(cave) == cave

  def parse(input) do
    input
    |> String.split()
    |> Enum.reduce(%{}, fn line, paths ->
      [from, to] = String.split(line, "-")
      paths = Map.update(paths, from, [to], &[to | &1])

      if from == "start" or to == "end" do
        paths
      else
        Map.update(paths, to, [from], &[from | &1])
      end
    end)
  end
end

paths = File.read!("input.txt") |> Day12.parse()
IO.puts ("Part 1: #{Day12.count_terminal(paths, true)}")
IO.puts ("Part 1: #{Day12.count_terminal(paths, false)}")

defmodule Day4 do

  def parse_input(input) do
    [numbers | rest] = input |> String.split("\n", trim: true)
    numbers = numbers |> String.split(",") |> Enum.map(&String.to_integer/1)
    boards = rest |> Enum.chunk_every(5) |> Enum.map(&parse_board/1)
    {numbers, boards}
  end

  defp parse_board(lines) do
    map = lines |> Enum.with_index(fn line, row ->
        numbers = line |> String.split() |> Enum.map(&String.to_integer/1)
        {row, numbers}
      end)
      |> Enum.flat_map(fn {row, nums} -> nums |> Enum.with_index(fn num, col -> {num, {row, col}} end)
      end) |> Enum.into(%{})
    {map, []}
  end

  def update_board({map, checked} = board, number) do
    case Map.get(map, number) do
      nil -> board
      position -> {map, [position | checked]}
    end
  end

  def board_winning?({_, marked}) do
    0..4 |> Enum.any?(fn x ->
      Enum.count(marked, fn {row, _} -> row == x end) == 5 or
        Enum.count(marked, fn {_, col} -> col == x end) == 5
    end)
  end

  defp score({map, marked}, final_num) do
    unmarked_sum = (Enum.filter(map, fn {_, pos} -> not Enum.member?(marked, pos) end)
    |> Enum.map(fn {n, _} -> n end)
    |> Enum.sum())
    final_num * unmarked_sum
  end

  def part_one(input) do
    {numbers, boards} = parse_input(input)

    Enum.reduce_while(numbers, boards, fn number, boards ->
      updated_boards = boards |> Enum.map(fn b -> Day4.update_board(b, number) end)
      winning_boards = updated_boards |> Enum.filter(&Day4.board_winning?/1)

      case winning_boards do
        [] -> {:cont, updated_boards}
        [winning_board] -> {:halt, score(winning_board, number)}
      end
    end)
  end

  def part_two(input) do
    {numbers, boards} = parse_input(input)

    Enum.reduce_while(numbers, boards, fn number, boards ->
      boards = boards |> Enum.map(fn b -> Day4.update_board(b, number) end)
      winning_boards = boards |> Enum.filter(&Day4.board_winning?/1)

      case {winning_boards, boards} do
        {[], _} -> {:cont, boards}
        {[final_board], [final_board]} -> {:halt, score(final_board, number)}
        _ -> remaining = boards |> Enum.reject(fn {map, _} ->
                winning_boards |> Enum.any?(fn {winning_map, _} ->
                  winning_map === map
                end)
              end)
              {:cont, remaining}
      end
    end)
  end
end

input = File.read!("input.txt")

IO.puts("Part 1 = #{Day4.part_one(input)}")
IO.puts("Part 2 = #{Day4.part_two(input)}")

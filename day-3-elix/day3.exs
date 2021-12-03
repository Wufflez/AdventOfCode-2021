use Bitwise

defmodule Day3 do
  # Outputs a list of 1 counts for each column
  def count_ones(rows) do
    Enum.zip(rows)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn col -> col |> Enum.count(fn ch -> ch == ?1 end) end)
  end

  def find_oxygen(rows), do: find_row(rows, 0, :majority) |> to_string() |> String.to_integer(2)
  def find_co2(rows), do: find_row(rows, 0, :minority) |> to_string() |> String.to_integer(2)

  defp find_row([row], _, _), do: row

  defp find_row(rows, position, mode) do
    ones = count_ones(rows)
    half_rows = length(rows) / 2

    # Mask used to filter rows
    filtermask =
      ones
      |> Enum.map(fn one_count ->
        case mode do
          :majority -> if one_count >= half_rows, do: ?1, else: ?0
          :minority -> if one_count < half_rows, do: ?1, else: ?0
        end
      end)

    # Rows that match the filter mask at 'position'
    filtered =
      rows |> Enum.filter(fn row -> Enum.at(row, position) == Enum.at(filtermask, position) end)

    # Search remaining filtered rows at the next bit position
    find_row(filtered, position + 1, mode)
  end
end

bit_rows = File.read!("input.txt") |> String.split() |> Enum.map(&String.to_charlist/1)
half_rows = length(bit_rows) / 2

# Part 1
num_ones = Day3.count_ones(bit_rows)

gamma =
  num_ones
  |> Enum.reduce(0, fn count, gamma ->
    (gamma <<< 1) + if count > half_rows, do: 1, else: 0
  end)

# Epsilon is just inverse of gamma (masked to just 5 bits)
epsilon = ~~~gamma &&& 31

IO.puts("Part 1 = #{gamma * epsilon}")

# Part 2
o2 = Day3.find_oxygen(bit_rows)
co2 = Day3.find_co2(bit_rows)
IO.puts("Part 2 = #{o2 * co2}")

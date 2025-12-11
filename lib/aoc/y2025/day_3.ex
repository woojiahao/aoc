defmodule AOC.Y2025.Day3 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 3

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(
      &(String.graphemes(&1)
        |> Enum.map(fn v -> String.to_integer(v) end)
        |> :array.from_list())
    )
  end

  @impl true
  def part_one(data, _opts) do
    Enum.sum_by(data, &solve(&1, 2))
  end

  @impl true
  def part_two(data, _opts) do
    Enum.sum_by(data, &solve(&1, 12))
  end

  defp solve(joltages, take), do: solve(joltages, 0, take, 0)
  defp solve(_, _, 0, acc), do: acc

  defp solve(joltages, l, take, acc) do
    i =
      largest_joltage(joltages, l, :array.size(joltages) - take + 1, l, :array.get(l, joltages))

    solve(joltages, i + 1, take - 1, acc * 10 + :array.get(i, joltages))
  end

  defp largest_joltage(_, l, l, idx, _), do: idx

  defp largest_joltage(joltages, l, r, idx, cur),
    do:
      if(:array.get(l, joltages) > cur,
        do: largest_joltage(joltages, l + 1, r, l, :array.get(l, joltages)),
        else: largest_joltage(joltages, l + 1, r, idx, cur)
      )
end

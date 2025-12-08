defmodule AOC.Y2025.Day5 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 5

  @impl true
  def load_data(data, _opts) do
    [ingredient_ranges_raw, ingredient_ids_raw] = String.split(data, "\n\n")

    ingredient_ranges =
      ingredient_ranges_raw
      |> String.split("\n")
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.map(&Enum.map(&1, fn v -> String.to_integer(v) end))
      |> Enum.sort()
      |> merge_intervals([])

    ingredient_ids = ingredient_ids_raw |> String.split("\n") |> Enum.map(&String.to_integer/1)

    {ingredient_ranges, ingredient_ids}
  end

  @impl true
  def part_one({ingredient_ranges, ingredient_ids}, _opts) do
    Enum.count(ingredient_ids, &within_range?(&1, ingredient_ranges))
  end

  @impl true
  def part_two({ingredient_ranges, _}, _opts) do
    Enum.sum_by(ingredient_ranges, fn [s, e] -> e - s + 1 end)
  end

  defp merge_intervals([], acc), do: Enum.reverse(acc)
  defp merge_intervals([h | rest], []), do: merge_intervals(rest, [h])

  defp merge_intervals([[s, e] | rest], [[a, b] | o]) when s <= b,
    do: merge_intervals(rest, [[a, max(e, b)] | o])

  defp merge_intervals([h | rest], acc), do: merge_intervals(rest, [h | acc])

  defp within_range?(ingredient_id, ingredient_ranges),
    do: Enum.any?(ingredient_ranges, fn [s, e] -> ingredient_id >= s and ingredient_id <= e end)
end

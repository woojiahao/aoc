defmodule AOC.Y2023.Day11 do
  @moduledoc false

  use AOC.Solution, year: 2023, day: 11

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Data.parse_as_grid()
    |> then(fn {grid, m, n} ->
      galaxies =
        grid |> Enum.filter(&(elem(&1, 1) == "#")) |> Enum.map(&elem(&1, 0))

      empty_rows =
        0..(m - 1)
        |> General.list_set_difference(Enum.map(galaxies, &elem(&1, 0)))
        |> Enum.sort()

      empty_cols =
        0..(n - 1)
        |> General.list_set_difference(Enum.map(galaxies, &elem(&1, 0)))
        |> Enum.sort()

      {MapSet.new(galaxies), empty_rows, empty_cols}
    end)
  end

  @impl true
  def part_one({galaxies, empty_rows, empty_cols}, _opts) do
    solve(galaxies, empty_rows, empty_cols, 2)
  end

  @impl true
  def part_two({galaxies, empty_rows, empty_cols}, _opts) do
    solve(galaxies, empty_rows, empty_cols, 1_000_000)
  end

  defp get_shift(point, list), do: get_shift(point, list, 0, length(list) - 1)
  defp get_shift(_point, _list, l, r) when l >= r, do: l
  defp get_shift(point, [f | _], _, _) when point < f, do: 0

  defp get_shift(point, list, l, r) do
    m = l + div(r - l, 2)

    cond do
      point > List.last(list) -> length(list)
      Enum.at(list, m) >= point -> get_shift(point, list, l, m)
      true -> get_shift(point, list, m + 1, r)
    end
  end

  defp solve(galaxies, empty_rows, empty_cols, growth) do
    expanded =
      galaxies
      |> Enum.map(fn {r, c} ->
        {
          r + get_shift(r, empty_rows) * (growth - 1),
          c + get_shift(c, empty_cols) * (growth - 1)
        }
      end)

    expanded
    |> General.distinct_pairs()
    |> Enum.map(fn {i, j} -> Math.manhattan(i, j) end)
    |> Enum.sum()
  end
end

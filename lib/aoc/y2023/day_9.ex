defmodule AOC.Y2023.Day9 do
  @moduledoc false
  use AOC.Solution, year: 2023, day: 9

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.map(&1, fn v -> String.to_integer(v) end))
    |> Enum.map(&get_diffs(&1, [General.first_last_tuple(&1)]))
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&Enum.slice(&1, 1..-1))
  end

  @impl true
  def part_one(data, _opts) do
    data |> Enum.map(&solve(&1, fn {_, v}, p -> v + p end, 0)) |> Enum.sum()
  end

  @impl true
  def part_two(data, _opts) do
    data |> Enum.map(&solve(&1, fn {v, _}, p -> v - p end, 0)) |> Enum.sum()
  end

  defp solve([], _, p), do: p
  defp solve([t | r], op, p), do: solve(r, op, op.(t, p))

  defp get_diffs(row, acc) do
    if Enum.any?(row, &(&1 != 0)) do
      row
      |> Enum.with_index()
      |> Enum.map(fn
        {_v, 0} -> Math.inf()
        {v, i} -> v - Enum.at(row, i - 1)
      end)
      |> Enum.reject(&(&1 == Math.inf()))
      |> then(&get_diffs(&1, acc ++ [General.first_last_tuple(&1)]))
    else
      acc
    end
  end
end

defmodule AOC.Y2024.Day9 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2024, 9)
    |> then(fn [line] ->
      line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce({[], false, 0}, fn
      v, {acc, false, i} ->
        {acc ++ List.duplicate(i, v), true, i + 1}

      v, {acc, true, i} ->
        {acc ++ List.duplicate(nil, v), false, i}
    end)
    |> elem(0)
  end

  @impl true
  def part_one(disks) do
    compact(disks, 0, length(disks) - 1)
    |> Enum.reject(&is_nil/1)
    |> Enum.with_index()
    |> General.map_sum(fn {v, i} -> v * i end)
  end

  @impl true
  def part_two(_data) do
    :not_implemented
  end

  defp compact(disk, l, r) when l >= r, do: disk

  defp compact(disk, l, r) do
    cond do
      !is_nil(Enum.at(disk, l)) -> compact(disk, l + 1, r)
      is_nil(Enum.at(disk, r)) -> compact(disk, l, r - 1)
      true -> compact(swap(disk, l, r), l + 1, r - 1)
    end
  end

  defp swap(arr, i, j) do
    a = Enum.at(arr, i)
    b = Enum.at(arr, j)
    arr |> List.replace_at(i, b) |> List.replace_at(j, a)
  end
end

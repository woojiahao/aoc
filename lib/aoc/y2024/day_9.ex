defmodule AOC.Y2024.Day9 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2024, 9)
    |> then(fn [line] ->
      line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  @impl true
  def part_one(data) do
    disks =
      data
      |> Enum.reduce({[], false, 0}, fn
        v, {acc, false, i} ->
          {acc ++ List.duplicate(i, v), true, i + 1}

        v, {acc, true, i} ->
          {acc ++ List.duplicate(nil, v), false, i}
      end)
      |> elem(0)
      |> Arrays.new(implementation: Arrays.Implementations.ErlangArray)

    compact(disks, 0, Arrays.size(disks) - 1)
    |> Enum.reject(&is_nil/1)
    |> Enum.with_index()
    |> General.map_sum(fn {v, i} -> v * i end)
  end

  @impl true
  def part_two(data) do
    files =
      data
      |> Enum.with_index()
      |> Enum.group_by(fn
        {_, k} when rem(k, 2) == 0 -> :file
        _ -> :free
      end)
      |> IO.inspect()

    files
  end

  defp first_fit(free, [file | file_rest], disk) do
    {_, free_slot_idx} = free_slot = Enum.find(free, fn slot -> slot >= file end)

    if is_nil(free_slot) do
      first_fit(free, file_rest, disk)
    else
      first_fit(free, file_rest, disk)
    end
  end

  defp compact(disk, l, r) when l >= r, do: disk

  defp compact(disk, l, r) do
    cond do
      !is_nil(disk[l]) -> compact(disk, l + 1, r)
      is_nil(disk[r]) -> compact(disk, l, r - 1)
      true -> compact(swap(disk, l, r), l + 1, r - 1)
    end
  end

  defp swap(arr, i, j) do
    a = arr[i]
    b = arr[j]

    put_in(arr[i], b)
    |> then(fn arr -> put_in(arr[j], a) end)
  end
end

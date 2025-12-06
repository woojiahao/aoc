defmodule AOC.Y2024.Day9 do
  @moduledoc false

  use AOC.Solution, year: 2024, day: 9

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> then(fn [line] ->
      line |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.reduce({[], false, 0}, fn
      v, {acc, false, i} ->
        {acc ++ List.duplicate(i, v), true, i + 1}

      v, {acc, true, i} ->
        {acc ++ List.duplicate(nil, v), false, i}
    end)
    |> elem(0)
    |> Arrays.new(implementation: Arrays.Implementations.ErlangArray)
    |> then(fn disks ->
      disks
      |> compact(0, Arrays.size(disks) - 1)
      |> Enum.reject(&is_nil/1)
      |> Enum.with_index()
      |> General.map_sum(fn {v, i} -> v * i end)
    end)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.with_index()
    |> Enum.map(fn
      {v, k} when rem(k, 2) == 0 -> %{type: :file, free: 0, data: List.duplicate(div(k, 2), v)}
      {v, _} -> %{type: :free, free: v, data: []}
    end)
    |> Arrays.new(implementation: Arrays.Implementations.ErlangArray)
    |> then(fn disk ->
      first_fit(disk, Arrays.size(disk) - 1)
      |> Enum.flat_map(fn %{data: data, free: free} -> data ++ List.duplicate(0, free) end)
    end)
    |> Enum.with_index()
    |> General.map_sum(fn {v, i} -> v * i end)
  end

  defp first_fit(disk, -1), do: disk

  defp first_fit(disk, r) do
    %{type: type, data: data} = disk[r]

    if type == :free do
      first_fit(disk, r - 1)
    else
      l =
        disk
        |> Enum.find_index(fn %{type: type, free: free} ->
          type == :free and free >= length(data)
        end)

      if is_nil(l) or l >= r do
        first_fit(disk, r - 1)
      else
        %{free: free_space, data: free_data} = disk[l]

        updated_disk =
          put_in(disk[l], %{disk[l] | free: free_space - length(data), data: free_data ++ data})
          |> then(fn new_disk ->
            put_in(new_disk[r], %{new_disk[r] | free: length(data), data: []})
          end)

        first_fit(updated_disk, r - 1)
      end
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

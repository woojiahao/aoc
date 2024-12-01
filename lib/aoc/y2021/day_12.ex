defmodule AOC.Y2021.Day12 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2021, 12)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.reduce(%{}, fn [a, b], acc ->
      acc
      |> Map.update(a, [b], fn v -> v ++ [b] end)
      |> Map.update(b, [a], fn v -> v ++ [a] end)
    end)
  end

  @impl true
  def part_one(data) do
    dfs(data, "start", MapSet.new(), [])
    |> Enum.map(&Enum.join(&1))
    |> length()
  end

  @impl true
  def part_two(data) do
    dfs(data, "start", MapSet.new(), [], 2)
    |> IO.inspect()
    |> Enum.map(&Enum.frequencies/1)
    |> IO.inspect()
    |> length()
  end

  defp dfs(cave, room, visited, path, small_visit_count \\ 1)
  defp dfs(_, "end", _, path, _), do: [Enum.reverse(["end" | path])]

  defp dfs(cave, "start", visited, path, small_visit_count) do
    if Map.get(visited, "start", 0) > 0 do
      []
    else
      for neighbor <- cave["start"] do
        dfs(
          cave,
          neighbor,
          Map.update(visited, "start", 1, fn x -> x + 1 end),
          ["start" | path],
          small_visit_count
        )
      end
      |> Enum.flat_map(& &1)
    end
  end

  defp dfs(cave, room, visited, path, small_visit_count) do
    can_revisit_smaller? =
      AOCString.lower?(room) and
        not Enum.any?(visited, fn {k, v} -> AOCString.lower?(k) and v == small_visit_count end)

    if AOCString.lower?(room) and not can_revisit_smaller? do
      []
    else
      for neighbor <- cave[room] do
        dfs(
          cave,
          neighbor,
          Map.update(visited, room, 1, fn x -> x + 1 end),
          [room | path],
          small_visit_count
        )
      end
      |> Enum.flat_map(& &1)
    end
  end
end

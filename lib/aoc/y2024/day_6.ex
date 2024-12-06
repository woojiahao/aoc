defmodule AOC.Y2024.Day6 do
  @moduledoc false

  use AOC.Solution

  @dirs [
    {-1, 0},
    {0, 1},
    {1, 0},
    {0, -1}
  ]

  @impl true
  def load_data() do
    Data.load_day_as_grid(2024, 6)
    |> then(fn {grid, _, _} ->
      start = grid |> Enum.find(fn {_, v} -> v == "^" end) |> elem(0)
      {grid, start}
    end)
  end

  @impl true
  def part_one({grid, start}) do
    walk(grid, 0, start, MapSet.new([]))
    |> MapSet.size()
  end

  @impl true
  def part_two({grid, start}) do
    grid
    |> walk(0, start, MapSet.new([]))
    |> Enum.filter(fn coord -> grid[coord] == "." end)
    |> General.map_sum(fn coord ->
      walk2(grid |> Map.put(coord, "#"), 0, start, MapSet.new([]))
    end)
  end

  defp walk(grid, dir, {r, c}, visited) do
    {dr, dc} = Enum.at(@dirs, dir)

    case Map.get(grid, {r + dr, c + dc}) do
      nil ->
        MapSet.put(visited, {r, c})

      n when n == "." or n == "^" ->
        walk(grid, dir, {r + dr, c + dc}, MapSet.put(visited, {r, c}))

      _ ->
        walk(grid, rem(dir + 1, 4), {r, c}, MapSet.put(visited, {r, c}))
    end
  end

  defp walk2(grid, dir, {r, c}, visited) do
    {dr, dc} = Enum.at(@dirs, dir)

    if MapSet.member?(visited, {dir, r + dr, c + dc}) do
      1
    else
      case Map.get(grid, {r + dr, c + dc}) do
        nil ->
          0

        n when n == "." or n == "^" ->
          walk2(grid, dir, {r + dr, c + dc}, MapSet.put(visited, {dir, r, c}))

        _ ->
          walk2(grid, rem(dir + 1, 4), {r, c}, MapSet.put(visited, {dir, r, c}))
      end
    end
  end
end

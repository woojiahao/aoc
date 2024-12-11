defmodule AOC.Y2024.Day10 do
  @moduledoc false

  use AOC.Solution

  @dirs [
    {-1, 0},
    {1, 0},
    {0, -1},
    {0, 1}
  ]

  @impl true
  def load_data() do
    Data.load_day_as_grid(2024, 10)
    |> then(fn {grid, m, n} ->
      Map.new(grid, fn {k, v} -> {k, String.to_integer(v)} end)
    end)
  end

  @impl true
  def part_one(grid) do
    grid
    |> Enum.filter(fn {_, v} -> v == 0 end)
    |> General.map_sum(fn {coord, _} -> grid |> search(coord, MapSet.new([coord])) |> length() end)
  end

  @impl true
  def part_two(grid) do
    grid
    |> Enum.filter(fn {_, v} -> v == 0 end)
    |> General.map_sum(fn {coord, _} ->
      distinct_search(grid, coord, MapSet.new([coord]))
    end)
  end

  defp search(grid, {r, c} = coord, visited) do
    if grid[coord] == 9 do
      [coord]
    else
      @dirs
      |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
      |> Enum.reject(fn new_coord ->
        is_nil(grid[new_coord]) or MapSet.member?(visited, new_coord) or
          grid[new_coord] != grid[coord] + 1
      end)
      |> Enum.flat_map(fn new_coord ->
        search(grid, new_coord, MapSet.put(visited, new_coord))
      end)
      |> Enum.uniq()
    end
  end

  defp distinct_search(grid, {r, c} = coord, visited) do
    if grid[coord] == 9 do
      1
    else
      @dirs
      |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
      |> Enum.reject(fn new_coord ->
        is_nil(grid[new_coord]) or MapSet.member?(visited, new_coord) or
          grid[new_coord] != grid[coord] + 1
      end)
      |> General.map_sum(fn new_coord ->
        distinct_search(grid, new_coord, MapSet.put(visited, new_coord))
      end)
    end
  end
end

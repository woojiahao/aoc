defmodule AOC.Y2024.Day12 do
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
    Data.load_day_as_grid(2024, 12)
  end

  @impl true
  def part_one({grid, m, n}) do
    Enum.reduce(General.generate_coord_list(m, n), {MapSet.new([]), 0}, fn coord,
                                                                           {visited, res} ->
      if MapSet.member?(visited, coord) do
        {visited, res}
      else
        region = search_region(grid, [coord], MapSet.new([coord]))
        area = MapSet.size(region)

        perimeter =
          region
          |> Enum.map(fn region_coord -> calculate_perimeter(grid, region_coord) end)
          |> Enum.sum()

        {MapSet.union(visited, region), res + area * perimeter}
      end
    end)
    |> elem(1)
  end

  @impl true
  def part_two(_data) do
    :not_implemented
  end

  defp calculate_perimeter(grid, {r, c} = coord) do
    @dirs
    |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
    |> Enum.reject(fn new_coord -> grid[coord] == grid[new_coord] end)
    |> Enum.count()
  end

  defp search_region(grid, frontier, visited) do
    new_frontier =
      frontier
      |> Enum.flat_map(fn {r, c} = coord ->
        @dirs
        |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
        |> Enum.reject(fn new_coord ->
          is_nil(grid[new_coord]) or grid[new_coord] != grid[coord] or
            MapSet.member?(visited, new_coord)
        end)
      end)
      |> MapSet.new()

    new_visited = MapSet.union(visited, new_frontier)

    if Enum.empty?(new_frontier) do
      new_visited
    else
      search_region(grid, new_frontier, new_visited)
    end
  end
end

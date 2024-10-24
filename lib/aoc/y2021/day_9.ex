defmodule AOC.Y2021.Day9 do
  @moduledoc false

  use AOC.Solution
  import Utils.Math, [:inf]
  import Utils.General, [:map_sum]

  @dirs [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  @impl true
  def load_data() do
    Data.load_day_as_grid(2021, 9)
    |> then(fn {grid, m, n} ->
      {Map.new(grid, fn {coord, v} -> {coord, String.to_integer(v)} end), m, n}
    end)
  end

  @impl true
  def part_one({grid, _, _}) do
    grid
    |> Enum.filter(fn {coord, _} -> low_point?(grid, coord) end)
    |> map_sum(&(elem(&1, 1) + 1))
  end

  @impl true
  def part_two({grid, m, n}) do
    grid
    |> Enum.filter(fn {coord, _} -> low_point?(grid, coord) end)
    |> Enum.map(fn {coord, _} -> coord end)
    |> Enum.map(fn coord -> bfs([coord], MapSet.new([coord]), grid, m, n) end)
    |> Enum.sort(:desc)
    |> Enum.slice(0..2//1)
    |> Enum.product()
  end

  defp low_point?(grid, {r, c}) do
    @dirs
    |> Enum.map(fn {dr, dc} -> Map.get(grid, {r + dr, c + dc}, inf()) end)
    |> Enum.count(fn v -> grid[{r, c}] < v end) == 4
  end

  defp bfs([], visited, _, _, _), do: MapSet.size(visited)

  defp bfs(frontier, visited, grid, m, n) do
    frontier
    |> Enum.flat_map(fn {r, c} ->
      @dirs
      |> Enum.map(fn {dr, dc} -> {dr + r, dc + c} end)
      |> Enum.filter(fn {nr, nc} ->
        nr >= 0 and nr < m and nc >= 0 and nc < n and not MapSet.member?(visited, {nr, nc}) and
          grid[{nr, nc}] != 9
      end)
    end)
    |> Enum.uniq()
    |> then(fn new_frontier ->
      bfs(new_frontier, MapSet.union(visited, MapSet.new(new_frontier)), grid, m, n)
    end)
  end
end

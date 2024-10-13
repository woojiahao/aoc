defmodule AOC.Y2022.Day12 do
  @moduledoc false

  use AOC.Solution
  import Utils.String, [:ord]
  import Utils.General, [:map_min]
  import Utils.Math, [:inf]

  @dirs [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  @impl true
  def load_data() do
    {grid, m, n} = Data.load_day_as_grid(2022, 12)
    start_pos = grid |> Enum.find(fn {_coord, v} -> v == "S" end) |> elem(0)
    end_pos = grid |> Enum.find(fn {_coord, v} -> v == "E" end) |> elem(0)
    {%{grid | start_pos => "a", end_pos => "z"}, start_pos, end_pos, m, n}
  end

  @impl true
  def part_one({grid, start_pos, end_pos, m, n}) do
    bfs(grid, [start_pos], end_pos, MapSet.new([start_pos]), m, n)
  end

  @impl true
  def part_two({grid, _start_pos, end_pos, m, n}) do
    grid
    |> Enum.filter(fn {_coord, v} -> v == "a" end)
    |> Enum.map(&elem(&1, 0))
    |> map_min(&bfs(grid, [&1], end_pos, MapSet.new([&1]), m, n))
  end

  defp bfs(_, [], _, _, _, _), do: inf()

  defp bfs(grid, frontier, end_pos, visited, m, n) do
    if Enum.member?(frontier, end_pos) do
      0
    else
      new_frontier = generate_frontier(grid, frontier, visited, m, n)
      new_visited = MapSet.union(visited, MapSet.new(new_frontier))
      bfs(grid, new_frontier, end_pos, new_visited, m, n) + 1
    end
  end

  defp generate_frontier(grid, frontier, visited, m, n) do
    frontier
    |> Enum.flat_map(fn {r, c} ->
      Enum.map(@dirs, fn {dr, dc} -> {{dr + r, dc + c}, {r, c}} end)
    end)
    |> Enum.reject(fn {{nr, nc} = neighbor, cur} ->
      nr not in 0..(m - 1) or
        nc not in 0..(n - 1) or
        MapSet.member?(visited, neighbor) or
        ord(grid[neighbor]) - ord(grid[cur]) > 1
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
  end
end

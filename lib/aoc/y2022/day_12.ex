defmodule AOC.Y2022.Day12 do
  @moduledoc false

  use AOC.Solution
  import Utils.String, [:ord]
  import Utils.General, [:map_min]
  import Utils.Graph, [:bfs_path_length]

  @impl true
  def load_data() do
    {grid, m, n} = Data.load_day_as_grid(2022, 12)
    start_pos = grid |> Enum.find(fn {_coord, v} -> v == "S" end) |> elem(0)
    end_pos = grid |> Enum.find(fn {_coord, v} -> v == "E" end) |> elem(0)
    {%{grid | start_pos => "a", end_pos => "z"}, start_pos, end_pos, m, n}
  end

  @impl true
  def part_one({grid, start_pos, end_pos, m, n}) do
    bfs(grid, start_pos, end_pos, m, n)
  end

  @impl true
  def part_two({grid, _start_pos, end_pos, m, n}) do
    grid
    |> Enum.filter(fn {_coord, v} -> v == "a" end)
    |> Enum.map(&elem(&1, 0))
    |> map_min(&bfs(grid, &1, end_pos, m, n))
  end

  defp bfs(grid, start_pos, end_pos, m, n) do
    bfs_path_length(
      grid,
      [start_pos],
      MapSet.new([start_pos]),
      m,
      n,
      fn neighbor, cur -> ord(grid[neighbor]) - ord(grid[cur]) <= 1 end,
      fn frontier -> Enum.member?(frontier, end_pos) end
    )
  end
end

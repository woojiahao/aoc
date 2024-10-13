defmodule Utils.Graph do
  @moduledoc false

  import Utils.Math, [:inf]

  @dirs [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def bfs_path_length(_, [], _, _, _, _, _), do: inf()

  def bfs_path_length(grid, frontier, visited, m, n, is_valid_neighbor?, is_end?) do
    if is_end?.(frontier) do
      0
    else
      new_frontier = generate_frontier(frontier, visited, m, n, is_valid_neighbor?)
      new_visited = MapSet.union(visited, MapSet.new(new_frontier))
      bfs_path_length(grid, new_frontier, new_visited, m, n, is_valid_neighbor?, is_end?) + 1
    end
  end

  defp generate_frontier(frontier, visited, m, n, is_valid_neighbor?) do
    frontier
    |> Enum.flat_map(fn {r, c} ->
      Enum.map(@dirs, fn {dr, dc} -> {{dr + r, dc + c}, {r, c}} end)
    end)
    |> Enum.reject(fn {{nr, nc} = neighbor, cur} ->
      nr not in 0..(m - 1) or
        nc not in 0..(n - 1) or
        MapSet.member?(visited, neighbor) or
        not is_valid_neighbor?.(neighbor, cur)
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.uniq()
  end
end

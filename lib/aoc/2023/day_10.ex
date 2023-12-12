defmodule AOC.TwentyTwentyThree.Day10 do
  @moduledoc false
  require Integer
  use AOC.Solution

  @directions [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
  @pipes %{
    "|" => [{-1, 0}, {1, 0}],
    "-" => [{0, -1}, {0, 1}],
    "L" => [{-1, 0}, {0, 1}],
    "J" => [{-1, 0}, {0, -1}],
    "7" => [{1, 0}, {0, -1}],
    "F" => [{1, 0}, {0, 1}]
  }

  @impl true
  def load_data do
    Data.load_day(10)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> then(&to_graph/1)
    |> then(fn {graph, m, n} ->
      start = graph |> Enum.find(&(elem(&1, 1)[:point] == "S")) |> elem(0)
      graph = put_in(graph[start][:neighbors], add_start_neighbors(graph, start, m, n))
      graph = graph
      {start, graph, m, n}
    end)
  end

  defp in_range?({r, c}, m, n), do: r >= 0 and r < m and c >= 0 and c < n

  defp add_start_neighbors(graph, {row, col}, m, n) do
    []
    |> General.prepend_if_true(
      check_pipe(graph, row, col, m, n, :up),
      [{row - 1, col}]
    )
    |> General.prepend_if_true(
      check_pipe(graph, row, col, m, n, :down),
      [{row + 1, col}]
    )
    |> General.prepend_if_true(
      check_pipe(graph, row, col, m, n, :left),
      [{row, col - 1}]
    )
    |> General.prepend_if_true(
      check_pipe(graph, row, col, m, n, :right),
      [{row, col + 1}]
    )
    |> Enum.reverse()
    |> Enum.filter(&in_range?(&1, m, n))
  end

  defp check_pipe(_, r, c, m, n, _) when r < 0 or r >= m or c < 0 or c >= n, do: false
  defp check_pipe(g, r, c, _m, _n, :up), do: g[{r - 1, c}][:point] in ~w(| 7 F)
  defp check_pipe(g, r, c, _m, _n, :down), do: g[{r + 1, c}][:point] in ~w(| L J)
  defp check_pipe(g, r, c, _m, _n, :right), do: g[{r, c + 1}][:point] in ~w(- 7 J)
  defp check_pipe(g, r, c, _m, _n, :left), do: g[{r, c - 1}][:point] in ~w(- L F)

  defp to_graph(points) do
    m = length(points)
    n = points |> Enum.at(0) |> length()

    assign_point = fn row, col ->
      p = points |> Enum.at(row) |> Enum.at(col)

      %{point: p}
      |> Map.merge(
        if Map.has_key?(@pipes, p),
          do: %{
            neighbors:
              @pipes[p]
              |> Enum.map(fn {dr, dc} -> {row + dr, col + dc} end)
              |> Enum.filter(&in_range?(&1, m, n))
          },
          else: %{}
      )
    end

    graph =
      Enum.reduce(0..(m - 1), %{}, fn row, acc ->
        col_acc =
          Enum.reduce(0..(n - 1), %{}, fn col, row_acc ->
            point_map = assign_point.(row, col)
            Map.put(row_acc, {row, col}, point_map)
          end)

        Map.merge(acc, col_acc)
      end)

    {graph, m, n}
  end

  @impl true
  def part_one({start, graph, m, n}) do
    bfs([start], graph, m, n, MapSet.new([start]), 0)
  end

  defp bfs([], _, _, _, _, steps), do: steps - 1

  defp bfs(q, graph, m, n, visited, steps) do
    frontier =
      q
      |> Enum.flat_map(fn {cr, cc} ->
        graph[{cr, cc}][:neighbors]
        |> Enum.reject(&MapSet.member?(visited, &1))
        |> Enum.filter(&Map.has_key?(@pipes, graph[&1][:point]))
      end)

    bfs(frontier, graph, m, n, MapSet.union(visited, MapSet.new(frontier)), steps + 1)
  end

  @impl true
  def part_two({start, graph, m, n}) do
    path = loop_path([start], graph, m, n, MapSet.new([start]))
    non_path = graph |> Map.keys() |> Enum.reject(&MapSet.member?(path, &1))

    non_path
    |> Enum.count(fn {r, c} ->
      {r, c}
      |> Stream.iterate(fn {i, j} -> {i + 1, j + 1} end)
      |> Stream.take_while(&in_range?(&1, m, n))
      |> Stream.filter(&MapSet.member?(path, &1))
      |> Stream.filter(&(graph[&1][:point] not in ~w(L 7)))
      |> Enum.count()
      |> then(&Integer.is_odd(&1))
    end)
  end

  defp loop_path([], _, _, _, visited), do: visited

  defp loop_path(q, graph, m, n, visited) do
    frontier =
      q
      |> Enum.flat_map(fn {cr, cc} ->
        graph[{cr, cc}][:neighbors]
        |> Enum.reject(&MapSet.member?(visited, &1))
        |> Enum.filter(&Map.has_key?(@pipes, graph[&1][:point]))
      end)

    loop_path(frontier, graph, m, n, MapSet.union(visited, MapSet.new(frontier)))
  end
end

defmodule AOC.Y2021.Day11 do
  @moduledoc false

  use AOC.Solution

  @dirs [
    {-1, 0},
    {1, 0},
    {0, -1},
    {0, 1},
    {-1, -1},
    {-1, 1},
    {1, -1},
    {1, 1}
  ]

  @impl true
  def load_data() do
    Data.load_day_as_grid(2021, 11)
    |> then(fn {grid, m, n} ->
      {Map.new(grid, fn {k, v} -> {k, String.to_integer(v)} end), m, n}
    end)
  end

  @impl true
  def part_one({grid, m, n}) do
    1..100
    |> Enum.reduce({grid, 0}, fn _, {acc_grid, acc_flashes} ->
      {updated_grid, step_flashes} = step(acc_grid, m, n)
      {updated_grid, step_flashes + acc_flashes}
    end)
    |> elem(1)
  end

  @impl true
  def part_two({grid, m, n}) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(grid, fn i, acc ->
      {updated_grid, flashed} = step(acc, m, n)

      if flashed == m * n do
        {:halt, i + 1}
      else
        {:cont, updated_grid}
      end
    end)
  end

  defp get_neighbors(r, c, m, n) do
    @dirs
    |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
    |> Enum.filter(fn {nr, nc} -> nr in 0..(m - 1) and nc in 0..(n - 1) end)
  end

  defp step(grid, m, n) do
    frontier =
      for i <- 0..(m - 1) do
        for j <- 0..(n - 1) do
          {:inc, {i, j}}
        end
      end
      |> Enum.flat_map(& &1)

    bfs(grid, m, n, frontier, MapSet.new())
  end

  defp bfs(grid, _, _, [], flashed), do: {grid, MapSet.size(flashed)}

  defp bfs(grid, m, n, [{:inc, coord} | rest], flashed) do
    if MapSet.member?(flashed, coord) do
      bfs(grid, m, n, rest, flashed)
    else
      updated_grid = %{grid | coord => grid[coord] + 1}

      if updated_grid[coord] == 10 do
        bfs(updated_grid, m, n, rest ++ [{:flash, coord}], flashed)
      else
        bfs(updated_grid, m, n, rest, flashed)
      end
    end
  end

  defp bfs(grid, m, n, [{:flash, {r, c} = coord} | rest], flashed) do
    if MapSet.member?(flashed, coord) do
      bfs(grid, m, n, rest, flashed)
    else
      updated_grid = %{grid | coord => 0}

      updated_frontier = Enum.map(get_neighbors(r, c, m, n), fn {nr, nc} -> {:inc, {nr, nc}} end)
      bfs(updated_grid, m, n, rest ++ updated_frontier, MapSet.put(flashed, coord))
    end
  end

  defp print_grid(grid, m, n) do
    for i <- 0..(m - 1) do
      for j <- 0..(n - 1) do
        grid[{i, j}]
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
  end
end

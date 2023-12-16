defmodule AOC.Y2023.Day16 do
  @moduledoc false
  use AOC.Solution

  @directions %{left: {0, -1}, right: {0, 1}, up: {-1, 0}, down: {1, 0}}

  @opposites %{left: :right, right: :left, up: :down, down: :up}

  # Use \ mirror by default
  @slanted %{left: :up, right: :down, up: :left, down: :right}

  @impl true
  def load_data() do
    Data.load_day_as_grid(16)
  end

  @impl true
  def part_one({grid, m, n}) do
    start_beam(grid, m, n, 0, 0, :right)
  end

  @impl true
  def part_two({grid, m, n}) do
    0..(m - 1)
    |> Enum.flat_map(&[{&1, 0, :right}, {&1, n - 1, :left}])
    |> Enum.concat(Enum.flat_map(0..(n - 1), &[{0, &1, :down}, {m - 1, &1, :up}]))
    |> General.map_max(fn {r, c, d} -> start_beam(grid, m, n, r, c, d) end)
  end

  defp next(".", dir), do: [dir]
  defp next("|", dir) when dir in ~w(up down)a, do: [dir]
  defp next("|", _), do: [:up, :down]
  defp next("-", dir) when dir in ~w(left right)a, do: [dir]
  defp next("-", _), do: [:left, :right]
  defp next("\\", dir), do: [@slanted[dir]]
  defp next("/", dir), do: [@slanted[@opposites[dir]]]

  defp start_beam(grid, m, n, sr, sc, sd),
    do: beam(grid, m, n, [{sr, sc, sd}], MapSet.new([{sr, sc, sd}]))

  defp beam(_, _, _, [], visited),
    do: visited |> Enum.uniq_by(fn {r, d, _} -> {r, d} end) |> Enum.count()

  defp beam(grid, m, n, frontier, visited) do
    next_frontier =
      frontier
      |> Enum.flat_map(fn {r, c, d} ->
        next(grid[{r, c}], d)
        |> Enum.map(fn td ->
          {dr, dc} = @directions[td]
          {r + dr, c + dc, td}
        end)
      end)
      |> Enum.reject(fn {r, c, _} = v ->
        r < 0 or r >= m or c < 0 or c >= n or MapSet.member?(visited, v)
      end)

    next_visited = MapSet.union(visited, MapSet.new(next_frontier))

    beam(grid, m, n, next_frontier, next_visited)
  end
end

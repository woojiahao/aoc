defmodule AOC.Y2025.Day4 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 4

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
  def load_data(data, _opts) do
    {grid, m, n} =
      data
      |> String.split("\n")
      |> Data.parse_as_grid()

    rolls =
      grid |> Enum.filter(&(elem(&1, 1) == "@")) |> Enum.map(&elem(&1, 0)) |> MapSet.new()

    {rolls, m, n}
  end

  @impl true
  def part_one({rolls, m, n}, _opts) do
    rolls
    |> Enum.map(&neighbors(&1, rolls, m, n))
    |> Enum.count(&(length(&1) < 4))
  end

  @impl true
  def part_two({rolls, m, n}, _opts) do
    rolls
    |> Map.new(fn coord -> {coord, coord |> neighbors(rolls, m, n) |> MapSet.new()} end)
    |> remove_rolls()
  end

  defp neighbors({r, c}, rolls, m, n) when is_struct(rolls, MapSet) do
    @dirs
    |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
    |> Enum.reject(fn {dr, dc} -> dr < 0 or dr >= m or dc < 0 or dc >= n end)
    |> Enum.filter(&MapSet.member?(rolls, &1))
  end

  defp neighbors(coord, rolls, m, n) do
    rolls_keys = rolls |> Map.keys() |> MapSet.new()
    neighbors(coord, rolls_keys, m, n)
  end

  defp remove_rolls(rolls) do
    frontier =
      rolls
      |> Enum.filter(&(MapSet.size(elem(&1, 1)) < 4))
      |> Enum.map(&elem(&1, 0))

    process_frontier(rolls, frontier, MapSet.new(frontier))
  end

  defp process_frontier(_, [], visited), do: MapSet.size(visited)

  defp process_frontier(rolls, frontier, visited) do
    {rolls, new_frontier, visited} =
      Enum.reduce(frontier, {rolls, [], visited}, fn coord, {g, f, v} ->
        neighbors = g[coord]

        Enum.reduce(neighbors, {g, f, v}, fn neighbor, {gg, ff, vv} ->
          new_set = MapSet.delete(gg[neighbor], coord)
          gg = Map.put(gg, neighbor, new_set)

          if MapSet.size(new_set) < 4 and not MapSet.member?(vv, neighbor) do
            {gg, [neighbor | ff], MapSet.put(vv, neighbor)}
          else
            {gg, ff, vv}
          end
        end)
      end)

    process_frontier(rolls, new_frontier, visited)
  end
end

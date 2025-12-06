defmodule AOC.Y2024.Day4 do
  @moduledoc false

  use AOC.Solution, year: 2024, day: 4

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
    data
    |> String.split("\n")
    |> Data.parse_as_grid()
  end

  @impl true
  def part_one({grid, _, _}, _opts) do
    grid
    |> Enum.filter(fn {_, v} -> v == "X" end)
    |> General.map_sum(fn {coord, _} -> count_xmas(grid, coord) end)
  end

  @impl true
  def part_two({grid, _, _}, _opts) do
    grid
    |> Enum.filter(fn {_, v} -> v == "A" end)
    |> Enum.count(fn {coord, _} -> has_x_mas(grid, coord) end)
  end

  defp has_x_mas(grid, {r, c}) do
    [tl, tr, bl, br] =
      @dirs
      |> Enum.slice(4..-1//1)
      |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
      |> Enum.map(fn coord -> Map.get(grid, coord, ".") end)

    ([tl, br] == ["M", "S"] or [tl, br] == ["S", "M"]) and
      ([tr, bl] == ["M", "S"] or [tr, bl] == ["S", "M"])
  end

  defp count_xmas(grid, {r, c}) do
    for {dr, dc} <- @dirs do
      0..3
      |> Enum.map(fn j -> {r + dr * j, c + dc * j} end)
      |> Enum.map_join(fn coord -> Map.get(grid, coord, ".") end)
    end
    |> Enum.count(fn v -> v == "XMAS" end)
  end
end

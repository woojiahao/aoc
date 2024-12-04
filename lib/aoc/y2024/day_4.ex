defmodule AOC.Y2024.Day4 do
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
  @xmas "XMAS"

  @impl true
  def load_data() do
    Data.load_day_as_grid(2024, 4)
  end

  @impl true
  def part_one({grid, m, n}) do
    grid
    |> Enum.filter(fn {_, v} -> v == "X" end)
    |> Enum.map(fn {k, _} -> k end)
    |> General.map_sum(fn coord -> count_xmas(grid, coord) end)
  end

  @impl true
  def part_two({grid, _, _}) do
    grid
    |> Enum.filter(fn {_, v} -> v == "A" end)
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.count(fn coord -> has_x_mas(grid, coord) end)
  end

  defp has_x_mas(grid, {r, c}) do
    [tl, tr, bl, br] =
      [{r - 1, c - 1}, {r - 1, c + 1}, {r + 1, c - 1}, {r + 1, c + 1}]
      |> Enum.map(fn coord -> Map.get(grid, coord, ".") end)

    ((tl == "M" and br == "S") or (tl == "S" and br == "M")) and
      ((tr == "M" and bl == "S") or (tr == "S" and bl == "M"))
  end

  defp count_xmas(grid, {r, c}) do
    for i <- 0..(length(@dirs) - 1) do
      {dr, dc} = Enum.at(@dirs, i)

      for j <- 0..3 do
        coord = {r + dr * j, c + dc * j}
        target = String.at(@xmas, j)
        v = Map.get(grid, coord, ".")
        target == v
      end
      |> Enum.all?()
    end
    |> Enum.count(fn v -> v == true end)
  end
end

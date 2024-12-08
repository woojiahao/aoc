defmodule AOC.Y2024.Day8 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day_as_grid(2024, 8)
    |> then(fn {grid, m, n} ->
      antennas =
        grid
        |> Enum.filter(fn {_, v} -> v != "." end)
        |> Enum.group_by(fn {_, v} -> v end, fn {k, _} -> k end)

      {antennas, m, n}
    end)
  end

  @impl true
  def part_one({antennas, m, n}) do
    antennas
    |> Enum.flat_map(fn {_, coords} ->
      find_antinodes(coords, m, n)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  @impl true
  def part_two({antennas, m, n}) do
    antennas
    |> Enum.flat_map(fn {_, coords} ->
      find_antinodes2(coords, m, n)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp find_antinodes(coords, m, n) do
    coords
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {coord, i} ->
      coords |> Enum.slice(i..-1//1) |> Enum.map(fn other -> {coord, other} end)
    end)
    |> Enum.flat_map(fn {{a, b}, {c, d}} ->
      da = abs(a - c)
      db = abs(b - d)
      da_sign = div(a - c, abs(a - c))
      db_sign = div(b - d, abs(b - d))
      nx = {a + da * da_sign, b + db * db_sign}
      ny = {c + da * -da_sign, d + db * -db_sign}
      [nx, ny]
    end)
    |> Enum.filter(fn {a, b} ->
      a in 0..(m - 1) and b in 0..(n - 1)
    end)
  end

  defp find_antinodes2(coords, m, n) do
    coords
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {coord, i} ->
      coords |> Enum.slice(i..-1//1) |> Enum.map(fn other -> {coord, other} end)
    end)
    |> Enum.flat_map(fn {x, y} ->
      inf_antinodes(x, y, m, n)
    end)
  end

  defp inf_antinodes({a, b}, {c, d}, m, n) do
    da = abs(a - c)
    db = abs(b - d)
    da_sign = div(a - c, abs(a - c))
    db_sign = div(b - d, abs(b - d))

    Stream.iterate({a, b}, fn {x, y} ->
      {x + da * da_sign, y + db * db_sign}
    end)
    |> Stream.take_while(fn {x, y} -> x in 0..(m - 1) and y in 0..(n - 1) end)
    |> Stream.concat(
      Stream.iterate({c, d}, fn {x, y} ->
        {x + da * -da_sign, y + db * -db_sign}
      end)
      |> Stream.take_while(fn {x, y} -> x in 0..(m - 1) and y in 0..(n - 1) end)
    )
    |> Enum.to_list()
    |> Enum.uniq()
  end
end

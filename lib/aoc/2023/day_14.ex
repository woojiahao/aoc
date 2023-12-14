defmodule AOC.TwentyTwentyThree.Day14 do
  @moduledoc false
  use AOC.Solution

  @impl true
  def load_data(), do: Data.load_day_as_grid(14)

  @impl true
  def part_one({grid, m, n}), do: grid |> tilt(m, n, :up) |> calculate_load(m)

  @impl true
  def part_two({grid, m, n}),
    do:
      0..effective(1_000_000_000)
      |> Enum.reduce(grid, fn _, acc -> cycle(acc, m, n) end)
      |> calculate_load(m)

  defp effective(n), do: rem(n - 140, 52) + 88

  defp cycle(grid, m, n),
    do:
      grid
      |> tilt(m, n, :up)
      |> tilt(m, n, :right)
      |> tilt(m, n, :down)
      |> tilt(m, n, :left)

  defp calculate_load(grid, m),
    do:
      grid
      |> Enum.filter(&(elem(&1, 1) == "O"))
      |> General.map_sum(fn {{r, _}, _} -> m - r end)

  defp tilt(grid, m, n, dir) do
    range(dir, m, n)
    |> Enum.reduce({init(dir, m, n), %{}}, fn i, {highest, acc} ->
      result =
        if dir == :up or dir == :down do
          Enum.map(0..(n - 1), &move(dir, grid[{i, &1}], i, &1, Enum.at(highest, &1)))
        else
          Enum.map(0..(m - 1), &move(dir, grid[{&1, i}], &1, i, Enum.at(highest, &1)))
        end

      {
        Enum.map(result, &List.first(&1)),
        Map.merge(acc, result |> Enum.flat_map(&List.last(&1)) |> Map.new())
      }
    end)
    |> elem(1)
  end

  defp range(:up, m, _), do: 0..(m - 1)
  defp range(:down, m, _), do: (m - 1)..0//-1
  defp range(:right, _, n), do: 0..(n - 1)
  defp range(:left, _, n), do: (n - 1)..0//-1

  defp init(:up, _, n), do: List.duplicate(0, n)
  defp init(:down, m, n), do: List.duplicate(m - 1, n)
  defp init(:right, m, _), do: List.duplicate(0, m)
  defp init(:left, m, n), do: List.duplicate(n - 1, m)

  defp move(:up, "#", r, c, _), do: [r + 1, %{{r, c} => "#"}]
  defp move(:up, "O", r, c, cur) when cur < r, do: [cur + 1, %{{r, c} => ".", {cur, c} => "O"}]
  defp move(:up, "O", r, c, r), do: [r + 1, %{{r, c} => "O"}]

  defp move(:down, "#", r, c, _), do: [r - 1, %{{r, c} => "#"}]
  defp move(:down, "O", r, c, cur) when cur > r, do: [cur - 1, %{{r, c} => ".", {cur, c} => "O"}]
  defp move(:down, "O", r, c, r), do: [r - 1, %{{r, c} => "O"}]

  defp move(:right, "#", r, c, _), do: [c + 1, %{{r, c} => "#"}]
  defp move(:right, "O", r, c, cur) when cur < c, do: [cur + 1, %{{r, c} => ".", {r, cur} => "O"}]
  defp move(:right, "O", r, c, c), do: [c + 1, %{{r, c} => "O"}]

  defp move(:left, "#", r, c, _), do: [c - 1, %{{r, c} => "#"}]
  defp move(:left, "O", r, c, cur) when cur > c, do: [cur - 1, %{{r, c} => ".", {r, cur} => "O"}]
  defp move(:left, "O", r, c, c), do: [c - 1, %{{r, c} => "O"}]

  defp move(_, cell, r, c, cur), do: [cur, %{{r, c} => cell}]
end

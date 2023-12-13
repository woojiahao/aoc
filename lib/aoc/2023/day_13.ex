defmodule AOC.TwentyTwentyThree.Day13 do
  @moduledoc false
  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(13, "\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&Enum.map(&1, fn line -> String.split(line, "", trim: true) end))
  end

  @impl true
  def part_one(data), do: General.map_sum(data, &solve/1)

  @impl true
  def part_two(data), do: General.map_sum(data, &solve(&1, true))

  defp solve(pattern, smudge? \\ false) do
    solve(pattern, General.rows_count(pattern), 0, smudge?)
    |> then(fn
      -1 -> pattern |> transpose() |> solve(General.cols_count(pattern), 0, smudge?)
      r -> r * 100
    end)
  end

  defp solve(_pattern, m, a, _smudge?) when a >= m - 1, do: -1

  defp solve(pattern, m, a, smudge?) do
    b = a + 1
    k = min(a + 1, m - b)
    upper = Enum.slice(pattern, (a + 1 - k)..a)
    lower = Enum.slice(pattern, b..(b + k - 1)) |> Enum.reverse()

    diff = upper |> Enum.zip(lower) |> General.map_sum(fn {u, l} -> compare(u, l, 0) end)

    if (smudge? and diff == 1) or (not smudge? and diff == 0),
      do: a + 1,
      else: solve(pattern, m, a + 1, smudge?)
  end

  defp compare(l1, l2, _) when length(l1) != length(l2), do: raise("Unequal list sizes!")
  defp compare([], [], d), do: d
  defp compare([a | j], [b | k], d) when a != b, do: compare(j, k, d + 1)
  defp compare([_ | j], [_ | k], d), do: compare(j, k, d)

  defp transpose(pattern) do
    0..(General.cols_count(pattern) - 1)
    |> Enum.map(fn r ->
      Enum.map(0..(General.rows_count(pattern) - 1), &(pattern |> Enum.at(&1) |> Enum.at(r)))
    end)
  end
end

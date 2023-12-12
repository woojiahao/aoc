defmodule AOC.TwentyTwentyThree.Day12 do
  @moduledoc false
  use AOC.Solution

  @impl true
  def load_data do
    Data.load_day(12)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn [springs, damaged] ->
      [
        springs |> String.split("", trim: true),
        damaged |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
      ]
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn [springs, damaged] -> solve(springs, damaged) end)
    |> Enum.sum()
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn [springs, damaged] ->
      [
        springs
        |> List.duplicate(5)
        |> Enum.flat_map(&(&1 ++ ["?"]))
        |> Enum.slice(0..-2),
        damaged |> List.duplicate(5) |> Enum.flat_map(& &1)
      ]
    end)
    |> Enum.map(fn [springs, damaged] -> solve(springs, damaged) end)
    |> Enum.sum()
  end

  defp solve(springs, damaged) do
    :ets.new(:memo, [:set, :protected, :named_table])
    ways = solve(springs, damaged, 0, 0, 0)
    :ets.delete(:memo)
    ways
  end

  defp solve(springs, damaged, i, j, c)
       when i == length(springs),
       do:
         (cond do
            j == length(damaged) and c == 0 -> 1
            j == length(damaged) - 1 and c == Enum.at(damaged, -1) -> 1
            true -> 0
          end)

  defp solve(springs, damaged, i, j, c) do
    key = {i, j, c}
    cached = :ets.lookup(:memo, key)

    if length(cached) > 0 do
      [{_, ways} | _] = cached
      ways
    else
      ch = Enum.at(springs, i)

      ways =
        if ch in ~w(. ?) do
          cond do
            c == 0 ->
              solve(springs, damaged, i + 1, j, 0)

            c > 0 and j < length(damaged) and Enum.at(damaged, j) == c ->
              solve(springs, damaged, i + 1, j + 1, 0)

            true ->
              0
          end
        else
          0
        end

      ways =
        ways +
          if ch in ~w(# ?),
            do: solve(springs, damaged, i + 1, j, c + 1),
            else: 0

      :ets.insert(:memo, {key, ways})
      ways
    end
  end
end

defmodule AOC.Y2024.Day1 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2024, 1)
    |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.reduce({[], []}, fn {a, b}, {l, r} -> {l ++ [a], r ++ [b]} end)
  end

  @impl true
  def part_one({l, r}) do
    l
    |> Enum.sort()
    |> Enum.zip(Enum.sort(r))
    |> General.map_sum(fn {a, b} -> abs(a - b) end)
  end

  @impl true
  def part_two({l, r}) do
    Enum.frequencies(r)
    |> then(fn freq ->
      General.map_sum(l, fn a -> a * Map.get(freq, a, 0) end)
    end)
  end
end

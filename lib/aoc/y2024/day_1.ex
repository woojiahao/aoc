defmodule AOC.Y2024.Day1 do
  @moduledoc false

  use AOC.Solution, year: 2024, day: 1

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ~r/\s+/, trim: true))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Array.transpose()
  end

  @impl true
  def part_one([l, r], _opts) do
    l
    |> Enum.sort()
    |> Enum.zip(Enum.sort(r))
    |> General.map_sum(fn {a, b} -> abs(a - b) end)
  end

  @impl true
  def part_two([l, r], _opts) do
    Enum.frequencies(r)
    |> then(fn freq ->
      General.map_sum(l, fn a -> a * Map.get(freq, a, 0) end)
    end)
  end
end

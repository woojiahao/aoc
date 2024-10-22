defmodule AOC.Y2021.Day6 do
  @moduledoc false

  use AOC.Solution
  import Utils.General, [:map_sum]

  @impl true
  def load_data() do
    Data.load_day(2021, 6)
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  @impl true
  def part_one(data) do
    simulate(data, 80)
  end

  @impl true
  def part_two(data) do
    simulate(data, 256)
  end

  defp simulate(population, 0), do: map_sum(population, fn {_, v} -> v end)

  defp simulate(population, days_remaining) do
    population
    |> Enum.map(fn {k, v} -> {k - 1, v} end)
    |> Map.new()
    |> then(fn up ->
      up
      |> Map.put(6, Map.get(up, 6, 0) + Map.get(up, -1, 0))
      |> Map.put(8, Map.get(up, -1, 0))
      |> Map.delete(-1)
    end)
    |> simulate(days_remaining - 1)
  end
end

defmodule AOC.Y2021.Day7 do
  @moduledoc false

  require Integer
  use AOC.Solution, year: 2021, day: 7
  import Utils.General, [:map_sum, :map_min]

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @impl true
  def part_one(data, _opts) do
    map_min(data, &calculate_fuel(&1, data))
  end

  @impl true
  def part_two(data, _opts) do
    {left, right} = Enum.min_max(data)
    map_min(left..right, &calculate_fuel_cumulative(&1, data))
  end

  defp calculate_fuel(dest, crabs) do
    map_sum(crabs, fn crab -> abs(crab - dest) end)
  end

  defp calculate_fuel_cumulative(dest, crabs) do
    map_sum(crabs, fn crab ->
      cost = abs(crab - dest)
      div(cost * (cost + 1), 2)
    end)
  end
end

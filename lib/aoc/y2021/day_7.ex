defmodule AOC.Y2021.Day7 do
  @moduledoc false

  require Integer
  use AOC.Solution
  import Utils.General, [:map_sum, :map_min]

  @impl true
  def load_data() do
    Data.load_day(2021, 7)
    |> hd()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @impl true
  def part_one(data) do
    map_min(data, &calculate_fuel(&1, data))
  end

  @impl true
  def part_two(data) do
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

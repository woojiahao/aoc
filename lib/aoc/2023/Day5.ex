defmodule AOC.TwentyTwentyThree.Day5 do
  @moduledoc """
  50 98 2 -> [98, 99] -> [50, 51]
  """

  use AOC.Solution

  @impl true
  def load_data do
    [
      "seeds: " <> seeds,
      "seed-to-soil map:\n" <> seed_to_soil,
      "soil-to-fertilizer map:\n" <> soil_to_fertilizer,
      "fertilizer-to-water map:\n" <> fertilizer_to_water,
      "water-to-light map:\n" <> water_to_light,
      "light-to-temperature map:\n" <> light_to_temperature,
      "temperature-to-humidity map:\n" <> temperature_to_humidity,
      "humidity-to-location map:\n" <> humidity_to_location
    ] = Data.load_day(5, "\n\n")

    processed_seeds = seeds |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    sts = process_map(seed_to_soil)
    stf = process_map(soil_to_fertilizer)
    ftw = process_map(fertilizer_to_water)
    wtl = process_map(water_to_light)
    ltt = process_map(light_to_temperature)
    tth = process_map(temperature_to_humidity)
    htl = process_map(humidity_to_location)

    {processed_seeds, [sts, stf, ftw, wtl, ltt, tth, htl]}
  end

  defp process_map(map) do
    map
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.map(&1, fn n -> String.to_integer(n) end))
    |> Enum.map(fn [d, s, r] -> {[s, s + r - 1], [d, d + r - 1]} end)
    |> Enum.sort()

    # |> IO.inspect(charlists: :as_lists)
  end

  @impl true
  def part_one(data) do
    {seeds, maps} = data
    seeds |> Enum.map(&dfs(&1, maps)) |> Enum.min()
  end

  defp dfs(num, []), do: num

  defp dfs(num, [mapping | rest]) do
    mapping
    |> Enum.find(fn {[first, last], _d} -> num >= first and num <= last end)
    |> then(fn
      nil ->
        num

      {[start, _last], [dest_start, _dest_last]} ->
        num - start + dest_start
    end)
    |> dfs(rest)
  end

  @impl true
  def part_two(data) do
    {seeds, maps} = data

    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, l] ->
      Task.async(fn ->
        start..(start + l - 1)
        |> Enum.map(&Task.async(fn -> dfs(&1, maps) end))
        |> Enum.map(&Task.await(&1, 50_000))
        |> Enum.min()
      end)
    end)
    |> Enum.flat_map(&Task.await(&1, :infinity))
    |> Enum.min()
  end

  defp solve(seed_range, [mapping | rest]) do
  end
end

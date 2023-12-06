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
    |> Enum.map(fn [seed_start, seed_length] ->
      solve([[seed_start, seed_start + seed_length - 1]], maps)
    end)
    |> Enum.flat_map(& &1)
    |> Enum.map(fn [first, _second] -> first end)
    |> Enum.min()
  end

  # Spreads the seed range into multiple smaller ranges that match the intervals
  defp spread(seed_ranges, intervals) do
    seed_ranges
    |> Enum.flat_map(fn [seed_start, seed_end] ->
      overlaps =
        intervals
        |> Enum.reject(fn {[first, last], _d} ->
          seed_start > last or seed_end < first
        end)
        |> Enum.map(fn {[first, last], _d} -> [max(seed_start, first), min(seed_end, last)] end)
        |> then(fn
          [] -> [[seed_start, seed_end]]
          otherwise -> otherwise
        end)

      [first_overlap_start, _] = List.first(overlaps)

      overlaps =
        if first_overlap_start > seed_start do
          # Leading overlap for seed
          [[seed_start, first_overlap_start - 1]] ++ overlaps
        else
          overlaps
        end

      [_, last_overlap_end] = List.last(overlaps)

      overlaps =
        if last_overlap_end < seed_end do
          overlaps ++ [[last_overlap_end + 1, seed_end]]
        else
          overlaps
        end

      overlaps
    end)
    |> Enum.map(fn [range_start, range_end] ->
      intervals
      |> Enum.find(fn {[interval_start, interval_end], _d} ->
        range_start <= interval_end and interval_start <= range_end
      end)
      |> then(fn
        nil ->
          [range_start, range_end]

        {[src_start, _src_end], [dest_start, _dest_end]} ->
          diff = dest_start - src_start
          [range_start + diff, range_end + diff]
      end)
    end)
  end

  defp solve(seed_ranges, []), do: seed_ranges

  defp solve(seed_ranges, [mapping | rest]) do
    seed_ranges
    |> spread(mapping)
    |> solve(rest)
  end
end

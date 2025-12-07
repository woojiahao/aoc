defmodule AOC.Y2025.Day2 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 2

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Flow.from_enumerable(stages: 8)
    |> Flow.partition(stages: 8)
    |> Flow.flat_map(fn [a, b] ->
      String.to_integer(a)..String.to_integer(b)//1
    end)
    |> Flow.filter(fn num ->
      num_s = Integer.to_string(num)
      l = String.length(num_s)

      rem(l, 2) == 0 and repeated?(num_s, div(l, 2))
    end)
    |> Flow.reduce(fn -> 0 end, &+/2)
    |> Flow.on_trigger(fn acc, _ -> {[acc], 0} end)
    |> Enum.sum()
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Flow.from_enumerable(stages: 8)
    # expand ranges into numbers (parallelized)
    |> Flow.flat_map(fn [a, b] ->
      String.to_integer(a)..String.to_integer(b)
    end)
    # keep only numbers that are "repeated" for some chunk size
    |> Flow.filter(fn num ->
      s = Integer.to_string(num)
      l = byte_size(s)
      # try all chunk sizes from 2 up to l/2; stop early if any matches
      2..div(l, 2)
      |> Enum.any?(fn cs -> rem(l, cs) == 0 and repeated?(s, cs) end)
    end)
    # route identical numbers to the same reducer so MapSet will dedupe globally
    |> Flow.partition(stages: 8, key: fn num -> num end)
    # accumulate unique numbers in a MapSet per partition
    |> Flow.reduce(fn -> MapSet.new() end, fn num, set -> MapSet.put(set, num) end)
    # emit the partition-local unique values as events
    |> Flow.on_trigger(fn set, _ -> {MapSet.to_list(set), MapSet.new()} end)
    # collect emitted numbers and sum them
    |> Enum.sum()
  end

  defp repeated?(num, chunk_size) do
    <<first::binary-size(chunk_size), rest::binary>> = num
    repeated?(rest, first, chunk_size)
  end

  defp repeated?("", _, _), do: true

  defp repeated?(num, first, chunk_size) do
    <<chunk::binary-size(chunk_size), rest::binary>> = num
    if chunk == first, do: repeated?(rest, first, chunk_size), else: false
  end
end

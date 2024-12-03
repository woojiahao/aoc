defmodule AOC.Y2024.Day3 do
  @moduledoc false

  use AOC.Solution

  @mul_regex ~r/mul\((\d+),(\d+)\)/
  @do_regex ~r/do\(\)/
  @dont_regex ~r/don\'t\(\)/

  @impl true
  def load_data() do
    Data.load_day(2024, 3)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.flat_map(fn line -> Regex.scan(@mul_regex, line, capture: :all_but_first) end)
    |> Enum.map(fn v -> Enum.map(v, &String.to_integer(&1)) end)
    |> General.map_sum(fn [a, b] -> a * b end)
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.join()
    |> conditional_mul()
  end

  defp conditional_mul(line) do
    mul_indices =
      Regex.scan(@mul_regex, line, return: :index)
      |> Enum.map(fn [{mul_idx, _}, {f, fl}, {s, sl}] ->
        {mul_idx, :mul, line |> String.slice(f, fl) |> String.to_integer(),
         line |> String.slice(s, sl) |> String.to_integer()}
      end)

    do_indices =
      Regex.scan(@do_regex, line, capture: :first, return: :index)
      |> Enum.flat_map(& &1)
      |> Enum.map(fn {i, _} -> {i, :do} end)

    dont_indices =
      Regex.scan(@dont_regex, line, capture: :first, return: :index)
      |> Enum.flat_map(& &1)
      |> Enum.map(fn {i, _} -> {i, :dont} end)

    do_indices
    |> Enum.concat(dont_indices)
    |> Enum.concat(mul_indices)
    |> Enum.sort(fn a, b -> elem(a, 0) < elem(b, 0) end)
    |> Enum.reduce({0, :do}, fn
      {_, :do}, {acc, _} -> {acc, :do}
      {_, :dont}, {acc, _} -> {acc, :dont}
      {_, :mul, a, b}, {acc, :do} -> {acc + a * b, :do}
      {_, :mul, _, _}, {acc, :dont} -> {acc, :dont}
    end)
    |> elem(0)
  end
end

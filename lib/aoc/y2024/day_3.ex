defmodule AOC.Y2024.Day3 do
  @moduledoc false

  use AOC.Solution

  @mul_regex ~r/mul\((\d+),(\d+)\)/
  @do_regex ~r/do\(\)/
  @dont_regex ~r/don\'t\(\)/

  @impl true
  def load_data() do
    Data.load_day(2024, 3)
    |> Enum.join()
  end

  @impl true
  def part_one(data) do
    Regex.scan(@mul_regex, data, capture: :all_but_first)
    |> Enum.map(fn v -> Enum.map(v, &String.to_integer(&1)) end)
    |> General.map_sum(fn [a, b] -> a * b end)
  end

  @impl true
  def part_two(data) do
    data
    |> get_do_instructions()
    |> Enum.concat(get_dont_instructions(data))
    |> Enum.concat(get_mul_instructions(data))
    |> Enum.sort(fn a, b -> elem(a, 0) < elem(b, 0) end)
    |> Enum.reduce({0, :do}, fn
      {_, :do}, {acc, _} -> {acc, :do}
      {_, :dont}, {acc, _} -> {acc, :dont}
      {_, :mul, a, b}, {acc, :do} -> {acc + a * b, :do}
      {_, :mul, _, _}, {acc, :dont} -> {acc, :dont}
    end)
    |> elem(0)
  end

  defp get_mul_instructions(data),
    do:
      Regex.scan(@mul_regex, data, return: :index)
      |> Enum.map(fn [{mul_idx, _}, {f, fl}, {s, sl}] ->
        {mul_idx, :mul, data |> String.slice(f, fl) |> String.to_integer(),
         data |> String.slice(s, sl) |> String.to_integer()}
      end)

  defp get_do_instructions(data),
    do:
      Regex.scan(@do_regex, data, capture: :first, return: :index)
      |> Enum.flat_map(& &1)
      |> Enum.map(fn {i, _} -> {i, :do} end)

  defp get_dont_instructions(data),
    do:
      Regex.scan(@dont_regex, data, capture: :first, return: :index)
      |> Enum.flat_map(& &1)
      |> Enum.map(fn {i, _} -> {i, :dont} end)
end

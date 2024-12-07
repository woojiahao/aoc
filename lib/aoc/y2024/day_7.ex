defmodule AOC.Y2024.Day7 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2024, 7)
    |> Enum.map(fn line -> String.split(line, ":") end)
    |> Enum.map(fn [test_value, numbers] ->
      {String.to_integer(test_value),
       numbers |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)}
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.filter(fn {test_value, numbers} -> form_test_value?(numbers, test_value) end)
    |> General.map_sum(fn {test_value, _} -> test_value end)
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.filter(fn {test_value, numbers} -> form_test_value2?(numbers, test_value) end)
    |> General.map_sum(fn {test_value, _} -> test_value end)
  end

  defp form_test_value?([acc | _], test_value) when acc > test_value, do: false
  defp form_test_value?([test_value], test_value), do: true
  defp form_test_value?([_], _), do: false

  defp form_test_value?([a | [b | rest]], test_value),
    do:
      form_test_value?([a * b | rest], test_value) or
        form_test_value?([a + b | rest], test_value)

  defp form_test_value2?([acc | _], test_value) when acc > test_value, do: false
  defp form_test_value2?([test_value], test_value), do: true
  defp form_test_value2?([_], _), do: false

  defp form_test_value2?([a | [b | rest]], test_value),
    do:
      form_test_value2?([a * b | rest], test_value) or
        form_test_value2?([a + b | rest], test_value) or
        form_test_value2?([String.to_integer("#{a}#{b}") | rest], test_value)
end

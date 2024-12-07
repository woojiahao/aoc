defmodule AOC.Y2024.Day7 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2024, 7)
    |> Enum.map(fn line -> String.split(line, ": ") end)
    |> Enum.map(fn [test_value, numbers] ->
      {String.to_integer(test_value),
       numbers |> String.split(" ") |> Enum.map(&String.to_integer/1)}
    end)
  end

  @impl true
  def part_one(data) do
    solve(data, false)
  end

  @impl true
  def part_two(data) do
    solve(data, true)
  end

  defp solve(data, has_concat) do
    data
    |> Enum.chunk_every(50)
    |> Task.async_stream(fn chunk ->
      chunk
      |> Enum.filter(fn {test_value, numbers} ->
        form_test_value?(numbers, test_value, has_concat)
      end)
      |> General.map_sum(fn {test_value, _} -> test_value end)
    end)
    |> Enum.reduce(0, fn {:ok, res}, acc -> acc + res end)
  end

  defp form_test_value?([acc | _], test_value, _) when acc > test_value, do: false
  defp form_test_value?([test_value], test_value, _), do: true
  defp form_test_value?([_], _, _), do: false

  defp form_test_value?([a | [b | rest]], test_value, false) do
    form_test_value?([a * b | rest], test_value, false) or
      form_test_value?([a + b | rest], test_value, false)
  end

  defp form_test_value?([a | [b | rest]], test_value, true) do
    form_test_value?([a * b | rest], test_value, true) or
      form_test_value?([a + b | rest], test_value, true) or
      form_test_value?([concat(a, concat(0, b)) | rest], test_value, true)
  end

  defp concat(a, 0), do: a
  defp concat(a, b), do: concat(a * 10 + rem(b, 10), div(b, 10))
end

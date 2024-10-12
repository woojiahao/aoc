defmodule AOC.Y2022.Day4 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2022, 4)
    |> Enum.map(fn line -> String.split(line, ",") end)
    |> Enum.map(fn [first, second] ->
      [a, b] = first |> String.split("-") |> Enum.map(&String.to_integer/1)
      [c, d] = second |> String.split("-") |> Enum.map(&String.to_integer/1)
      {{a, b}, {c, d}}
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.count(fn {{a, b}, {c, d}} -> (a >= c and b <= d) or (c >= a and d <= b) end)
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.count(fn {{a, b}, {c, d}} -> a <= d and c <= b end)
  end
end

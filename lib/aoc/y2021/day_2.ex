defmodule AOC.Y2021.Day2 do
  @moduledoc false

  use AOC.Solution, year: 2021, day: 2

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.reduce({0, 0}, fn
      "forward " <> x, {a, b} -> {a + String.to_integer(x), b}
      "down " <> x, {a, b} -> {a, b + String.to_integer(x)}
      "up " <> x, {a, b} -> {a, b - String.to_integer(x)}
    end)
    |> then(fn {a, b} -> a * b end)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.reduce({0, 0, 0}, fn
      "down " <> v, {x, y, a} -> {x, y, a + String.to_integer(v)}
      "up " <> v, {x, y, a} -> {x, y, a - String.to_integer(v)}
      "forward " <> v, {x, y, a} -> {x + String.to_integer(v), y + String.to_integer(v) * a, a}
    end)
    |> then(fn {a, b, _} -> a * b end)
  end
end

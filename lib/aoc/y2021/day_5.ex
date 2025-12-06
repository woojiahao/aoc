defmodule AOC.Y2021.Day5 do
  @moduledoc false

  use AOC.Solution, year: 2021, day: 5

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " -> ") end)
    |> Enum.map(fn [from, to] -> {String.split(from, ","), String.split(to, ",")} end)
    |> Enum.map(fn {[a, b], [c, d]} ->
      {{String.to_integer(a), String.to_integer(b)}, {String.to_integer(c), String.to_integer(d)}}
    end)
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.reject(fn {{a, b}, {c, d}} -> a != c and b != d end)
    |> Enum.flat_map(fn
      {{a, b}, {a, d}} -> for y <- b..d, do: {a, y}
      {{a, b}, {c, b}} -> for x <- a..c, do: {x, b}
    end)
    |> Enum.frequencies()
    |> Enum.count(fn {_, c} -> c > 1 end)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Stream.flat_map(fn
      {{a, b}, {c, d}} when a != c and b != d -> Stream.zip(a..c, b..d)
      {{a, b}, {a, d}} -> Stream.map(b..d, fn y -> {a, y} end)
      {{a, b}, {c, b}} -> Stream.map(a..c, fn x -> {x, b} end)
    end)
    |> Enum.frequencies()
    |> Enum.count(fn {_, c} -> c > 1 end)
  end
end

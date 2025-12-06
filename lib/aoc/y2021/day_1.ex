defmodule AOC.Y2021.Day1 do
  @moduledoc false

  use AOC.Solution, year: 2021, day: 1
  import Utils.General, [:zip_neighbor]

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> zip_neighbor()
    |> Enum.count(fn {a, b} -> b > a end)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn [a, b, c] -> a + b + c end)
    |> zip_neighbor()
    |> Enum.count(fn {a, b} -> b > a end)
  end
end

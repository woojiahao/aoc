defmodule AOC.Y2022.Day1 do
  @moduledoc false

  use AOC.Solution, year: 2022, day: 1

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n\n")
    |> Enum.map(fn elf ->
      elf |> String.split("\n") |> Enum.map(&String.to_integer/1) |> Enum.sum()
    end)
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.max()
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end

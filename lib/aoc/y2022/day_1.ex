defmodule AOC.Y2022.Day1 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2022, 1, "\n\n")
    |> Enum.map(fn elf ->
      elf |> String.split("\n") |> Enum.map(&String.to_integer/1) |> Enum.sum()
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.max()
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end

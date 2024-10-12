defmodule AOC.Y2022.Day3 do
  @moduledoc false

  use AOC.Solution
  import Utils.String, [:ord]
  import Utils.Set, [:list_intersection]

  @impl true
  def load_data() do
    Data.load_day(2022, 3)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn line ->
      len = String.length(line)
      half = div(len, 2)
      {String.slice(line, 0..(half - 1)), String.slice(line, half..len)}
    end)
    |> Enum.map(fn {first, second} ->
      list_intersection(String.to_charlist(first), String.to_charlist(second))
    end)
    |> Enum.map(&hd/1)
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] ->
      list_intersection(String.to_charlist(a), String.to_charlist(b))
      |> list_intersection(String.to_charlist(c))
    end)
    |> Enum.map(&hd/1)
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
  end

  defp priority(value) when value in ?a..?z, do: value - ord("a") + 1
  defp priority(value) when value in ?A..?Z, do: value - ord("A") + 27
end

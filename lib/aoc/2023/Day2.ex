defmodule AOC.TwentyTwentyThree.Day2 do
  @moduledoc false

  use AOC.Solution

  @red_limit 12
  @green_limit 13
  @blue_limit 14

  @impl true
  def load_data do
    Data.load_day(2) |> Enum.map(&parse_line/1)
  end

  defp parse_line("Game " <> game) do
    [id, sets] = game |> String.split(": ")

    parsed_sets =
      sets
      |> String.split("; ")
      |> Enum.map(&String.split(&1, ", "))
      |> Enum.map(fn grab -> Enum.map(grab, &String.split(&1, " ")) end)
      |> Enum.map(fn grab ->
        Enum.map(grab, fn [count, color] -> {String.to_atom(color), String.to_integer(count)} end)
      end)

    red_max = parsed_sets |> Enum.max_by(&Keyword.get(&1, :red, 0)) |> Keyword.get(:red, 0)
    green_max = parsed_sets |> Enum.max_by(&Keyword.get(&1, :green, 0)) |> Keyword.get(:green, 0)
    blue_max = parsed_sets |> Enum.max_by(&Keyword.get(&1, :blue, 0)) |> Keyword.get(:blue, 0)

    {String.to_integer(id), [red: red_max, green: green_max, blue: blue_max]}
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.filter(fn {id, [red: red, green: green, blue: blue]} ->
      red <= @red_limit && green <= @green_limit && blue <= @blue_limit
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn {_id, [red: red, green: green, blue: blue]} ->
      red * green * blue
    end)
    |> Enum.sum()
  end
end

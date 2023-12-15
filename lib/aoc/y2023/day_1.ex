defmodule AOC.Y2023.Day1 do
  @moduledoc false

  use AOC.Solution

  @numbers %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }
  @all_numbers @numbers
               |> Enum.flat_map(fn {key, value} ->
                 [
                   {key, value},
                   {String.reverse(key), value},
                   {Integer.to_string(value), value}
                 ]
               end)

  @impl true
  def load_data() do
    Data.load_day(1)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn str ->
      str
      |> String.graphemes()
      |> Enum.map(&Integer.parse/1)
      |> Enum.filter(fn ch -> ch != :error end)
      |> Enum.map(&elem(&1, 0))
    end)
    |> Enum.map(fn lst -> List.first(lst) * 10 + List.last(lst) end)
    |> Enum.sum()
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn str -> [parse_next(str), parse_next(String.reverse(str))] end)
    |> Enum.map(fn [first, last] -> first * 10 + last end)
    |> Enum.sum()
  end

  defp parse_final(digit), do: digit

  defp parse_next(str) do
    with index <- Enum.find(@all_numbers, &String.starts_with?(str, elem(&1, 0))),
         false <- is_nil(index),
         {_word, digit} <- index do
      parse_final(digit)
    else
      _ -> parse_next(String.slice(str, 1..-1))
    end
  end
end

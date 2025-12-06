defmodule AOC.Y2023.Day4 do
  @moduledoc false

  use AOC.Solution, year: 2023, day: 4

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&parse_row/1)
  end

  defp parse_row("Card" <> row) do
    row = String.trim(row)
    [card_no, rest] = String.split(row, ":", trim: true)
    [winning, numbers] = String.split(rest, "|", trim: true)

    [String.to_integer(card_no), parse_numbers(winning), parse_numbers(numbers)]
  end

  defp parse_numbers(numbers),
    do: numbers |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new()

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.reduce(0, fn [_card_no, winning, card], acc ->
      matching = MapSet.intersection(winning, card)

      if MapSet.size(matching) == 0,
        do: acc,
        else: acc + :math.pow(2, MapSet.size(matching) - 1)
    end)
    |> trunc()
  end

  @impl true
  def part_two(data, _opts) do
    counter = Map.new(data, fn [card_no, _, _] -> {card_no, 1} end)

    data
    |> Enum.reduce(counter, fn [card_no, winning, cards], acc ->
      with matching <- MapSet.intersection(winning, cards),
           matching_count <- MapSet.size(matching),
           true <- matching_count != 0,
           cur_count <- Map.get(acc, card_no, 1),
           duplicates <- (card_no + 1)..(card_no + matching_count),
           updated_map <- Map.new(duplicates, &{&1, Map.get(acc, &1, 1) + cur_count}) do
        Map.merge(acc, updated_map)
      else
        _ -> acc
      end
    end)
    |> Enum.filter(fn {key, _value} -> Map.has_key?(counter, key) end)
    |> Enum.map(fn {_key, value} -> value end)
    |> Enum.sum()
  end
end

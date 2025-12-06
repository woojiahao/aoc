defmodule AOC.Y2023.Day7 do
  @moduledoc false
  use AOC.Solution, year: 2023, day: 7

  @card_values ~w(2 3 4 5 6 7 8 9 T J Q K A) |> Enum.with_index(1) |> Map.new()
  @card_values_with_jokers ~w(J 2 3 4 5 6 7 8 9 T Q K A) |> Enum.with_index(1) |> Map.new()

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn [hand, bid] -> [hand, String.to_integer(bid)] end)
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.map(fn [hand, bid] -> [rank(hand), hand, bid] end)
    |> solve(@card_values)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.map(fn [hand, bid] -> [rank_jokers(hand), hand, bid] end)
    |> solve(@card_values_with_jokers)
  end

  defp hash(hand, values), do: hand |> String.graphemes() |> Enum.map(&Map.get(values, &1))

  defp solve(data, values),
    do:
      data
      |> Enum.sort_by(fn [w, h, _] -> {w, hash(h, values)} end)
      |> Enum.with_index(1)
      |> Enum.map(fn {[_, _, b], i} -> b * i end)
      |> Enum.sum()

  defp rank_jokers(hand),
    do:
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.reject(&(elem(&1, 0) == "J"))
      |> Enum.max_by(&elem(&1, 1), fn -> {"J", 0} end)
      |> elem(0)
      |> then(&(hand |> String.replace("J", &1) |> rank()))

  defp rank(hand),
    do:
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.map(&elem(&1, 1))
      |> Enum.sort()
      |> then(
        &case length(&1) do
          5 -> 1
          4 -> 2
          3 -> if &1 == [1, 2, 2], do: 3, else: 4
          2 -> if &1 == [2, 3], do: 5, else: 6
          1 -> 7
        end
      )
end

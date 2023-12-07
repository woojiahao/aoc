defmodule AOC.TwentyTwentyThree.Day7 do
  @moduledoc false
  use AOC.Solution

  @card_values ~w(2 3 4 5 6 7 8 9 T J Q K A) |> Enum.with_index(1) |> Map.new()

  @card_values_with_jokers ~w(J 2 3 4 5 6 7 8 9 T Q K A) |> Enum.with_index(1) |> Map.new()

  defp hash_hand(hand, values) do
    hand
    |> String.graphemes()
    |> Enum.map(&Map.get(values, &1))
  end

  @impl true
  def load_data do
    Data.load_day(7)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn [hand, bid] -> [hand, String.to_integer(bid)] end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn [hand, bid] -> [process_hand_weight(hand), hand, bid] end)
    |> solve(@card_values)
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn [hand, bid] -> [process_with_jokers(hand), hand, bid] end)
    |> solve(@card_values_with_jokers)
  end

  defp solve(data, values) do
    data
    |> Enum.sort_by(fn [w, h, _] -> {w, hash_hand(h, values)} end)
    |> Enum.with_index(1)
    |> Enum.map(fn {[_, _, b], i} -> b * i end)
    |> Enum.sum()
  end

  defp process_with_jokers(hand) do
    hand
    |> String.graphemes()
    |> Enum.frequencies()
    |> Enum.reject(&(elem(&1, 0) == "J"))
    |> Enum.max_by(&elem(&1, 1), fn -> {"J", 0} end)
    |> elem(0)
    |> then(fn most_non_joker_card ->
      hand |> String.replace("J", most_non_joker_card) |> process_hand_weight()
    end)
  end

  defp process_hand_weight(hand) do
    hand =
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.map(&elem(&1, 1))
      |> Enum.sort()

    case length(hand) do
      5 -> 1
      4 -> 2
      3 -> if hand == [1, 2, 2], do: 3, else: 4
      2 -> if hand == [2, 3], do: 5, else: 6
      1 -> 7
    end
  end
end

defmodule AOC.TwentyTwentyThree.Day7 do
  @moduledoc false
  use AOC.Solution

  @card_values %{
    "2" => 3,
    "3" => 5,
    "4" => 7,
    "5" => 11,
    "6" => 13,
    "7" => 17,
    "8" => 19,
    "9" => 23,
    "T" => 29,
    "J" => 31,
    "Q" => 37,
    "K" => 41,
    "A" => 43
  }

  @card_values_with_jokers %{
    "J" => 3,
    "2" => 5,
    "3" => 7,
    "4" => 11,
    "5" => 13,
    "6" => 17,
    "7" => 19,
    "8" => 23,
    "9" => 29,
    "T" => 31,
    "Q" => 37,
    "K" => 41,
    "A" => 43
  }

  defp hash_hand(hand, values) do
    hand
    |> String.graphemes()
    |> Enum.map(&Map.get(values, &1))
  end

  @impl true
  def load_data do
    Data.load_day(7)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn [hand, bid] ->
      [hand, String.to_integer(bid)]
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn [hand, bid] ->
      [process_hand_weight(hand), hand, bid]
    end)
    |> Enum.sort_by(fn [w, h, _] -> {w, hash_hand(h, @card_values)} end)
    |> Enum.with_index(1)
    |> Enum.map(fn {[_, _, b], i} -> b * i end)
    |> Enum.sum()
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

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn [hand, bid] ->
      [process_with_jokers(hand), hand, bid]
    end)
    |> Enum.sort_by(fn [w, h, _] -> {w, hash_hand(h, @card_values_with_jokers)} end)
    |> IO.inspect(charlists: :as_lists)
    |> Enum.with_index(1)
    |> Enum.map(fn {[_, _, b], i} -> b * i end)
    |> Enum.sum()
  end

  defp process_with_jokers(hand) do
    card_count =
      hand
      |> String.graphemes()
      |> Enum.frequencies()

    joker_count = Map.get(card_count, "J", 0)
    original_hand_weight = process_hand_weight(hand)

    # Joker count => 1
    # high card -> one pair
    # one pair -> three of a kind
    # two pair -> full house
    # three of a kind -> four of a kind
    # full house (not possible)
    # four of a kind -> five of a kind

    # Joker count => 2
    # high card (not possible)
    # one pair -> joker is the pair -> three of a kind
    # two pair -> joker is one of them -> four of a kind
    # three of a kind -> five of a kind (joker pair converts to other three)
    # full house -> five of a kind
    # four of a kind (not possible)

    # Joker count => 3
    # high card (not possible)
    # one pair (not possible)
    # two pair (not possible)
    # three of a kind (all jokers) -> four of a kind
    # full house (jokers + pair) -> five of a kind
    # four of a kind (not possible)
    case joker_count do
      0 ->
        original_hand_weight

      1 ->
        case original_hand_weight do
          1 -> 2
          2 -> 4
          3 -> 5
          4 -> 6
          6 -> 7
        end

      2 ->
        case original_hand_weight do
          2 -> 4
          3 -> 6
          4 -> 7
          5 -> 7
        end

      3 ->
        case original_hand_weight do
          4 -> 6
          5 -> 7
        end

      4 ->
        7

      5 ->
        7

      _ ->
        1
    end
  end
end

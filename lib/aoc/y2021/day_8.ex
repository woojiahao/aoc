defmodule AOC.Y2021.Day8 do
  @moduledoc false

  use AOC.Solution
  import Utils.General, [:map_sum]

  @impl true
  def load_data() do
    Data.load_day(2021, 8)
    |> Enum.map(fn line -> String.split(line, "|", trim: true) end)
    |> Enum.map(fn [digits, signal] ->
      {digits |> String.split(" ", trim: true) |> Enum.map(&String.graphemes/1),
       String.split(signal, " ", trim: true)}
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.flat_map(fn {digits, signal} ->
      mapping = decrypt(digits)
      Enum.map(signal, fn val -> Enum.find_index(mapping, fn m -> sorted_eq(val, m) end) end)
    end)
    |> Enum.count(fn v -> v in [1, 4, 7, 8] end)
  end

  @impl true
  def part_two(data) do
    data
    |> map_sum(fn {digits, signal} ->
      mapping = decrypt(digits)

      Enum.map_join(signal, &Enum.find_index(mapping, fn m -> sorted_eq(&1, m) end))
      |> String.to_integer()
    end)
  end

  defp decrypt(digits) do
    digit_frequency = digits |> Enum.flat_map(& &1) |> Enum.frequencies()
    one = Enum.find(digits, &(length(&1) == 2))
    four = Enum.find(digits, &(length(&1) == 4))
    seven = Enum.find(digits, &(length(&1) == 3))
    eight = Enum.find(digits, &(length(&1) == 7))
    e = digit_frequency |> Enum.find(fn {_, v} -> v == 4 end) |> elem(0)
    b = digit_frequency |> Enum.find(fn {_, v} -> v == 6 end) |> elem(0)
    f = digit_frequency |> Enum.find(fn {_, v} -> v == 9 end) |> elem(0)

    [a] = seven -- one
    [g] = (eight -- four) -- [e, a]
    [c] = one -- [f]
    [d] = ["a", "b", "c", "d", "e", "f", "g"] -- [a, b, c, e, f, g]
    sorted_digits = Enum.map(digits, &Enum.sort(&1))

    zero = assign_digit([a, b, c, e, f, g], sorted_digits)
    two = assign_digit([a, c, d, e, g], sorted_digits)
    three = assign_digit([a, c, d, f, g], sorted_digits)
    five = assign_digit([a, b, d, f, g], sorted_digits)
    six = assign_digit([a, b, d, e, f, g], sorted_digits)
    nine = assign_digit([a, b, c, d, f, g], sorted_digits)

    [zero, one, two, three, four, five, six, seven, eight, nine]
  end

  defp assign_digit(mapping, sorted_digits),
    do: Enum.find(sorted_digits, &(Enum.sort(&1) == Enum.sort(mapping)))

  defp sorted_eq(a, b), do: a |> String.graphemes() |> Enum.sort() == Enum.sort(b)
end

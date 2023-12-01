defmodule AOC.TwentyTwentyThree.Day1 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(1)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn str ->
      digits =
        str
        |> String.graphemes()
        |> Enum.map(&Integer.parse/1)
        |> Enum.filter(fn ch -> ch != :error end)
        |> Enum.map(&elem(&1, 0))

      first = List.first(digits)
      last = List.last(digits)

      first * 10 + last
    end)
    |> Enum.sum()
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn str -> [parse!(str), parse!(String.reverse(str))] end)
    |> Enum.map(fn [first, last] -> first * 10 + last end)
    |> Enum.sum()
  end

  defp parse!(word), do: parse(word, nil)
  defp parse("", front), do: front
  defp parse("one" <> rest, nil), do: parse(rest, 1)
  defp parse("one" <> rest, front), do: parse(rest, front)
  defp parse("eno" <> rest, nil), do: parse(rest, 1)
  defp parse("eno" <> rest, front), do: parse(rest, front)
  defp parse("two" <> rest, nil), do: parse(rest, 2)
  defp parse("two" <> rest, front), do: parse(rest, front)
  defp parse("owt" <> rest, nil), do: parse(rest, 2)
  defp parse("owt" <> rest, front), do: parse(rest, front)
  defp parse("three" <> rest, nil), do: parse(rest, 3)
  defp parse("three" <> rest, front), do: parse(rest, front)
  defp parse("eerht" <> rest, nil), do: parse(rest, 3)
  defp parse("eerht" <> rest, front), do: parse(rest, front)
  defp parse("four" <> rest, nil), do: parse(rest, 4)
  defp parse("four" <> rest, front), do: parse(rest, front)
  defp parse("ruof" <> rest, nil), do: parse(rest, 4)
  defp parse("ruof" <> rest, front), do: parse(rest, front)
  defp parse("five" <> rest, nil), do: parse(rest, 5)
  defp parse("five" <> rest, front), do: parse(rest, front)
  defp parse("evif" <> rest, nil), do: parse(rest, 5)
  defp parse("evif" <> rest, front), do: parse(rest, front)
  defp parse("six" <> rest, nil), do: parse(rest, 6)
  defp parse("six" <> rest, front), do: parse(rest, front)
  defp parse("xis" <> rest, nil), do: parse(rest, 6)
  defp parse("xis" <> rest, front), do: parse(rest, front)
  defp parse("seven" <> rest, nil), do: parse(rest, 7)
  defp parse("seven" <> rest, front), do: parse(rest, front)
  defp parse("neves" <> rest, nil), do: parse(rest, 7)
  defp parse("neves" <> rest, front), do: parse(rest, front)
  defp parse("eight" <> rest, nil), do: parse(rest, 8)
  defp parse("eight" <> rest, front), do: parse(rest, front)
  defp parse("thgie" <> rest, nil), do: parse(rest, 8)
  defp parse("thgie" <> rest, front), do: parse(rest, front)
  defp parse("nine" <> rest, nil), do: parse(rest, 9)
  defp parse("nine" <> rest, front), do: parse(rest, front)
  defp parse("enin" <> rest, nil), do: parse(rest, 9)
  defp parse("enin" <> rest, front), do: parse(rest, front)

  defp parse(<<ch::binary-1>> <> rest, nil) do
    case Integer.parse(ch) do
      {digit, _} -> parse(rest, digit)
      _ -> parse(rest, nil)
    end
  end

  defp parse(<<_ch::binary-1>> <> rest, front), do: parse(rest, front)
end

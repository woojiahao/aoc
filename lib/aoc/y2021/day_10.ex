defmodule AOC.Y2021.Day10 do
  @moduledoc false

  use AOC.Solution

  @braces ~w(\( [ { <)

  @opening %{
    "]" => "[",
    "}" => "{",
    ">" => "<",
    ")" => "("
  }

  @costs %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25_137
  }

  @completion_costs %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  @impl true
  def load_data() do
    Data.load_day(2021, 10)
    |> Enum.map(&String.graphemes/1)
  end

  @impl true
  def part_one(data) do
    General.map_sum(data, &corrupted/1)
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.filter(&(corrupted(&1) == 0))
    |> Enum.map(&complete/1)
    |> Enum.sort()
    |> then(fn l -> Enum.at(l, div(length(l), 2)) end)
  end

  defp complete(braces), do: complete(braces, [])

  defp complete([], stack),
    do: Enum.reduce(stack, 0, fn b, acc -> acc * 5 + @completion_costs[b] end)

  defp complete([top | rest], stack) when top in @braces,
    do: complete(rest, [top | stack])

  defp complete([top | rest], stack) do
    if @opening[top] == List.first(stack),
      do: complete(rest, tl(stack)),
      else: complete(rest, stack)
  end

  defp corrupted(braces), do: corrupted(braces, [])
  defp corrupted([], _), do: 0
  defp corrupted([top | rest], stack) when top in @braces, do: corrupted(rest, [top | stack])
  defp corrupted([top | _], []), do: @costs[top]

  defp corrupted([top | rest], [recent | others]) do
    if @opening[top] == recent, do: corrupted(rest, others), else: @costs[top]
  end
end

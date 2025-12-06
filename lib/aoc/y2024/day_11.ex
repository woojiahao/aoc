defmodule AOC.Y2024.Day11 do
  @moduledoc false

  require Integer
  use AOC.Solution, year: 2024, day: 11

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> then(fn [line] ->
      line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end

  @impl true
  def part_one(rocks, _opts) do
    solve(rocks, 25)
  end

  @impl true
  def part_two(rocks, _opts) do
    solve(rocks, 75)
  end

  defp solve(rocks, n) do
    1..n
    |> Enum.reduce(Enum.frequencies(rocks), fn _, rock_freq ->
      rock_freq
      |> Enum.reduce(%{}, fn {v, f}, new_rock_freq ->
        blink(v)
        |> Enum.reduce(new_rock_freq, fn new_v, acc ->
          Map.update(acc, new_v, f, fn prev -> prev + f end)
        end)
      end)
    end)
    |> General.map_sum(fn {_, f} -> f end)
  end

  defp blink(rock) do
    cond do
      rock == 0 -> [1]
      Integer.is_even(digits(rock)) -> split_num(rock)
      true -> [rock * 2024]
    end
  end

  defp digits(num), do: num |> Integer.digits() |> length()

  defp split_num(num) do
    v = Integer.digits(num)

    v
    |> Enum.split(div(length(v), 2))
    |> then(fn {a, b} ->
      [list_to_integer(a, 0), list_to_integer(b, 0)]
    end)
  end

  defp list_to_integer([], acc), do: acc
  defp list_to_integer([d | rest], acc), do: list_to_integer(rest, acc * 10 + d)
end

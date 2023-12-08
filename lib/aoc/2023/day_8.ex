defmodule AOC.TwentyTwentyThree.Day8 do
  @moduledoc false
  use AOC.Solution

  @impl true
  def load_data do
    Data.load_day(8, "\n\n")
    |> then(fn [instructions, map] ->
      [
        String.split(instructions, "", trim: true),
        map
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, " = ", trim: true))
        |> Enum.map(fn [from, to] ->
          {from, to |> String.slice(1..-2) |> String.split(", ", trim: true)}
        end)
        |> Map.new()
      ]
    end)
  end

  defp next_instruction(element, idx, instructions, map) do
    if(Enum.at(instructions, idx) == "L", do: 0, else: 1)
    |> then(&(map |> Map.get(element) |> Enum.at(&1)))
  end

  @impl true
  def part_one(data) do
    data |> then(fn [instructions, map] -> lookup(0, "AAA", instructions, map, 0) end)
  end

  defp lookup(_idx, "ZZZ", _instructions, _map, steps), do: steps

  defp lookup(idx, element, instructions, map, steps) do
    lookup(
      General.cyclic_index_next(idx, instructions),
      next_instruction(element, idx, instructions, map),
      instructions,
      map,
      steps + 1
    )
  end

  @impl true
  def part_two(data) do
    data
    |> then(fn [instructions, map] ->
      map
      |> Map.keys()
      |> Enum.filter(&String.ends_with?(&1, "A"))
      |> Enum.map(&ghost(0, &1, instructions, map, 0))
      |> Math.lcm()
    end)
  end

  defp ghost(_idx, <<_::binary-2>> <> "Z", _instructions, _map, steps), do: steps

  defp ghost(idx, element, instructions, map, steps) do
    ghost(
      General.cyclic_index_next(idx, instructions),
      next_instruction(element, idx, instructions, map),
      instructions,
      map,
      steps + 1
    )
  end
end

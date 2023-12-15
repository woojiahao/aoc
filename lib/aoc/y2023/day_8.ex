defmodule AOC.Y2023.Day8 do
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
        |> Map.new(fn <<from::binary-3>> <>
                        " = " <> "(" <> <<left::binary-3>> <> ", " <> <<right::binary-3>> <> ")" ->
          {from, [left, right]}
        end)
      ]
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> then(fn [instructions, map] ->
      traverse("AAA", 0, 0, fn el -> el == "ZZZ" end, instructions, map)
    end)
  end

  @impl true
  def part_two(data) do
    data
    |> then(fn [instructions, map] ->
      map
      |> Map.keys()
      |> Enum.filter(&String.ends_with?(&1, "A"))
      |> Enum.map(&traverse(&1, 0, 0, fn el -> String.ends_with?(el, "Z") end, instructions, map))
      |> Math.lcm()
    end)
  end

  defp traverse(element, idx, steps, goal?, instructions, map) do
    if goal?.(element) do
      steps
    else
      traverse(
        if(Enum.at(instructions, idx) == "L", do: 0, else: 1)
        |> then(&(map |> Map.get(element) |> Enum.at(&1))),
        General.cyclic_index_next(idx, instructions),
        steps + 1,
        goal?,
        instructions,
        map
      )
    end
  end
end

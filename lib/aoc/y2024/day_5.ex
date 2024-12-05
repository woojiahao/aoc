defmodule AOC.Y2024.Day5 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2024, 5, "\n\n")
    |> then(fn [rules, updates] ->
      rules =
        rules
        |> String.split("\n")
        |> Enum.map(fn rule ->
          Regex.run(~r/(\d+)\|(\d+)/, rule, capture: :all_but_first) |> List.to_tuple()
        end)
        |> MapSet.new()

      updates =
        updates
        |> String.split("\n")
        |> Enum.map(fn update -> String.split(update, ",") end)

      {rules, updates}
    end)
  end

  @impl true
  def part_one({rules, updates}) do
    updates
    |> Enum.filter(fn update -> right_order?(rules, update) end)
    |> General.map_sum(fn update ->
      update |> Enum.at(div(length(update), 2)) |> String.to_integer()
    end)
  end

  @impl true
  def part_two({rules, updates}) do
    updates
    |> Enum.reject(fn update -> right_order?(rules, update) end)
    |> Enum.map(fn update ->
      Enum.sort(update, fn a, b -> cmp(rules, a, b) end)
    end)
    |> General.map_sum(fn update ->
      update |> Enum.at(div(length(update), 2)) |> String.to_integer()
    end)
  end

  defp cmp(rules, a, b) do
    cond do
      MapSet.member?(rules, {a, b}) -> true
      MapSet.member?(rules, {b, a}) -> false
      true -> true
    end
  end

  defp right_order?(rules, update) do
    update
    |> Enum.with_index(1)
    |> Enum.map(fn {v, i} -> update |> Enum.slice(i..-1//1) |> Enum.map(fn k -> {v, k} end) end)
    |> Enum.all?(fn order ->
      Enum.all?(order, fn {a, b} -> !MapSet.member?(rules, {b, a}) end)
    end)
  end
end

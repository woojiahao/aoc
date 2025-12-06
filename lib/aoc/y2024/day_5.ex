defmodule AOC.Y2024.Day5 do
  @moduledoc false

  use AOC.Solution, year: 2024, day: 5

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n\n")
    |> then(fn [rules, updates] ->
      {
        rules
        |> String.split("\n")
        |> Enum.map(&(&1 |> String.split("|") |> List.to_tuple()))
        |> MapSet.new(),
        updates
        |> String.split("\n")
        |> Enum.map(&String.split(&1, ","))
      }
    end)
  end

  @impl true
  def part_one({rules, updates}, _opts) do
    updates
    |> Enum.filter(fn update -> right_order?(rules, update) end)
    |> General.map_sum(fn update ->
      update |> Enum.at(div(length(update), 2)) |> String.to_integer()
    end)
  end

  @impl true
  def part_two({rules, updates}, _opts) do
    updates
    |> Enum.reject(fn update -> right_order?(rules, update) end)
    |> Enum.map(fn update ->
      Enum.sort(update, fn a, b -> not MapSet.member?(rules, {b, a}) end)
    end)
    |> General.map_sum(fn update ->
      update |> Enum.at(div(length(update), 2)) |> String.to_integer()
    end)
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

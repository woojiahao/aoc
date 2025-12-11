defmodule AOC.Y2025.Day11 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 11

  import General, only: [bool_to_int: 1]

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Map.new(fn [i, o] -> {i, String.split(o, " ")} end)
  end

  @impl true
  def part_one(data, _opts) do
    paths("you", data)
  end

  @impl true
  def part_two(data, _opts) do
    paths_2("svr", data, 0, %{}) |> elem(0)
  end

  defp paths("out", _), do: 1
  defp paths(node, graph), do: Enum.sum_by(graph[node], &paths(&1, graph))

  defp paths_2("out", _, 2, memo), do: {1, memo}
  defp paths_2("out", _, _, memo), do: {0, memo}

  defp paths_2(node, _, found, memo) when is_map_key(memo, {node, found}),
    do: {memo[{node, found}], memo}

  defp paths_2(node, graph, found, memo) do
    Enum.reduce(graph[node], {0, memo}, fn n, {acc, m} ->
      paths_2(n, graph, found + bool_to_int(n in ~w(dac fft)), m)
      |> then(fn {res, m2} -> {acc + res, m2} end)
    end)
    |> then(fn {s, m} -> {s, Map.put(m, {node, found}, s)} end)
  end
end

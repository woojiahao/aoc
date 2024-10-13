defmodule AOC.Y2022.Day8 do
  @moduledoc false

  use AOC.Solution
  import Utils.General, [:generate_coord_list, :map_max]

  @dirs [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  @impl true
  def load_data() do
    Data.load_day_as_grid(2022, 8)
    |> then(fn {trees, m, n} ->
      {Map.new(trees, fn {key, value} -> {key, String.to_integer(value)} end), m, n}
    end)
  end

  @impl true
  def part_one({_trees, m, n} = data) do
    generate_coord_list(m, n)
    |> Enum.count(fn {r, c} ->
      Enum.any?(@dirs, fn {dr, dc} -> visible?(r, c, data, dr, dc) end)
    end)
  end

  @impl true
  def part_two({_trees, m, n} = data) do
    generate_coord_list(m, n)
    |> map_max(fn {r, c} ->
      @dirs
      |> Enum.map(fn {dr, dc} -> scenic(r, c, data, dr, dc) end)
      |> Enum.product()
    end)
  end

  defp visible?(r, c, {trees, m, n}, dr, dc) do
    Stream.iterate({r, c}, fn {a, b} -> {a + dr, b + dc} end)
    |> Stream.take_while(fn {a, b} = cur ->
      cur == {r, c} or (a >= 0 and a < m and b >= 0 and b < n and trees[cur] < trees[{r, c}])
    end)
    |> Enum.to_list()
    |> List.last()
    |> then(fn {lr, lc} -> lr == 0 or lr == m - 1 or lc == 0 or lc == n - 1 end)
  end

  defp scenic(r, c, {trees, m, n}, dr, dc) do
    Stream.iterate({r, c}, fn {a, b} -> {a + dr, b + dc} end)
    |> Stream.take_while(fn {a, b} = cur ->
      cur == {r, c} or (a >= 0 and a < m and b >= 0 and b < n and trees[cur] < trees[{r, c}])
    end)
    |> Enum.to_list()
    |> Enum.reverse()
    |> then(fn [{lr, lc} | _rest] = l ->
      if lr == 0 or lr == m - 1 or lc == 0 or lc == n - 1 do
        Enum.count(l) - 1
      else
        Enum.count(l)
      end
    end)
  end
end

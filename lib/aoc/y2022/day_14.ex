defmodule AOC.Y2022.Day14 do
  @moduledoc false

  use AOC.Solution
  import Utils.General, [:zip_neighbor, :map_min_max]

  @excess_floor 150

  @impl true
  def load_data() do
    map =
      Data.load_day(2022, 14)
      |> Enum.map(&String.split(&1, " -> "))
      |> Enum.map(fn paths ->
        paths
        |> Enum.map(&String.split(&1, ","))
        |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
      end)
      |> Enum.flat_map(fn paths ->
        zip_neighbor(paths)
        |> Enum.flat_map(fn {{x1, y1}, {x2, y2}} ->
          for x <- min(x1, x2)..max(x1, x2) do
            for y <- min(y1, y2)..max(y1, y2) do
              {x, y}
            end
          end
        end)
      end)
      |> Enum.flat_map(& &1)
      |> Map.new(fn coord -> {coord, "#"} end)

    {min_x, max_x} = map_min_max(map, fn {{x, _y}, _} -> x end)
    {min_y, max_y} = map_min_max(map, fn {{_x, y}, _} -> y end)

    {map, min_x, max_x, min_y, max_y}
  end

  @impl true
  def part_one({map, min_x, max_x, _min_y, _max_y}) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({map, 0}, fn _, {acc_map, i} ->
      updated_map = drop(acc_map, {500, 0}, min_x, max_x)

      if updated_map == :halt do
        {:halt, {acc_map, i}}
      else
        {:cont, {updated_map, i + 1}}
      end
    end)
    |> then(fn {map, i} ->
      draw_map(map)
      |> IO.puts()

      i
    end)
  end

  @impl true
  def part_two({map, min_x, max_x, _min_y, max_y}) do
    map_with_floor =
      Enum.reduce((min_x - @excess_floor)..(max_x + @excess_floor), map, fn x, acc ->
        Map.put(acc, {x, max_y + 2}, "#")
      end)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({map_with_floor, 0}, fn _, {acc_map, i} ->
      updated_map = drop(acc_map, {500, 0}, min_x - @excess_floor, max_x + @excess_floor)

      if updated_map == :halt do
        {:halt, {acc_map, i + 1}}
      else
        {:cont, {updated_map, i + 1}}
      end
    end)
    |> then(fn {map, i} ->
      draw_map(map)
      |> IO.puts()

      i
    end)
  end

  defp drop(_map, {px, _py}, min_x, max_x) when px < min_x or px > max_x, do: :halt

  defp drop(map, {px, py}, min_x, max_x) when not is_map_key(map, {px, py + 1}),
    do: drop(map, {px, py + 1}, min_x, max_x)

  defp drop(map, {px, py}, min_x, max_x) when not is_map_key(map, {px - 1, py + 1}),
    do: drop(map, {px - 1, py + 1}, min_x, max_x)

  defp drop(map, {px, py}, min_x, max_x) when not is_map_key(map, {px + 1, py + 1}),
    do: drop(map, {px + 1, py + 1}, min_x, max_x)

  defp drop(_map, {500, 0}, _, _), do: :halt
  defp drop(map, {px, py}, _, _), do: Map.put(map, {px, py}, "o")

  defp draw_map(map) do
    {min_x, max_x} = map_min_max(map, fn {{x, _y}, _} -> x end)
    {_min_y, max_y} = map_min_max(map, fn {{_x, y}, _} -> y end)

    for y <- 0..max_y do
      for x <- min_x..max_x do
        cond do
          is_map_key(map, {x, y}) -> map[{x, y}]
          {x, y} == {500, 0} -> "+"
          true -> "."
        end
      end
    end
    |> Enum.map_join("\n", fn line -> Enum.join(line, "") end)
  end
end

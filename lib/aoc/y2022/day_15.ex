defmodule AOC.Y2022.Day15 do
  @moduledoc false

  use AOC.Solution, year: 2022, day: 15
  import Utils.General, [:map_max, :map_min_max]

  @regex ~r/^Sensor at x=([-\d]+), y=([-\d]+): closest beacon is at x=([-\d]+), y=([-\d]+)$/

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(fn line -> Regex.run(@regex, line, capture: :all_but_first) end)
    |> Enum.map(fn parts -> Enum.map(parts, &String.to_integer/1) end)
    |> then(fn sensors ->
      grid =
        sensors
        |> Enum.flat_map(fn [sx, sy, bx, by] -> [{{sx, sy}, "S"}, {{bx, by}, "B"}] end)
        |> Map.new()

      radii =
        sensors
        |> Map.new(fn [sx, sy, bx, by] -> {{sx, sy}, abs(sx - bx) + abs(sy - by)} end)

      {grid, radii}
    end)
  end

  @impl true
  def part_one({grid, radii}, _opts) do
    {min_x, max_x} = map_min_max(grid, fn {{x, _}, _} -> x end) |> IO.inspect()
    max_r = map_max(radii, fn {_, r} -> r end)

    Enum.count((min_x - max_r)..(max_x + max_r), fn x ->
      !Map.has_key?(grid, {x, 2_000_000}) and under_sensor?(x, 2_000_000, radii)
    end)
  end

  @impl true
  def part_two({_grid, radii}, _opts) do
    radii
    |> Stream.flat_map(fn {{x, y}, r} ->
      Stream.concat(
        for xi <- (x - r - 1)..x do
          dy = abs(xi - x + (r + 1))
          [{xi, y + dy}, {xi, y - dy}]
        end,
        for xi <- x..(x + r + 1) do
          dy = abs(x - xi + (r + 1))
          [{xi, y + dy}, {xi, y - dy}]
        end
      )
      |> Stream.flat_map(& &1)
      |> Stream.uniq()
    end)
    |> Stream.reject(fn {x, y} ->
      x < 0 or x > 4_000_000 or y < 0 or y > 4_000_000 or under_sensor?(x, y, radii)
    end)
    |> Stream.uniq()
    |> Enum.to_list()
    |> hd()
    |> then(fn {x, y} -> x * 4_000_000 + y end)
  end

  defp under_sensor?(x, y, radii) do
    Enum.any?(radii, fn {{sx, sy}, r} -> abs(sx - x) + abs(sy - y) <= r end)
  end

  defp draw_grid(grid) do
    {min_x, max_x} = map_min_max(grid, fn {{x, _}, _} -> x end)
    {min_y, max_y} = map_min_max(grid, fn {{_, y}, _} -> y end)

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        if Map.has_key?(grid, {x, y}), do: grid[{x, y}], else: "."
      end
    end
    |> Enum.map_join("\n", fn line -> Enum.join(line, "") end)
  end
end

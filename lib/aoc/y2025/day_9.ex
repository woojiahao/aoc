defmodule AOC.Y2025.Day9 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 9

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Data.parse_as_coords()
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> General.distinct_pairs()
    |> Enum.max_by(fn {a, b} -> area(a, b) end)
    |> then(fn {a, b} -> area(a, b) end)
  end

  @impl true
  def part_two(data, _opts) do
    set_coords = MapSet.new(data)

    {vertical_lines, horizontal_lines} = group_coords(data)

    data
    |> General.distinct_pairs()
    |> Enum.map(fn {di, dj} -> {area(di, dj), di, dj} end)
    |> Enum.sort(:desc)
    |> Enum.find(fn {_, di, dj} ->
      rectangle_valid?(di, dj, set_coords, vertical_lines, horizontal_lines)
    end)
    |> elem(0)
  end

  defp group_coords(coords) do
    coords
    |> Enum.zip(coords |> Enum.slice(1..-1//1) |> Kernel.++([Enum.at(coords, 0)]))
    |> Enum.reduce({[], []}, fn
      {{ax, ay}, {ax, by}}, {v, h} when ay <= by -> {[{ax, ay, by} | v], h}
      {{ax, ay}, {ax, by}}, {v, h} -> {[{ax, by, ay} | v], h}
      {{ax, ay}, {bx, ay}}, {v, h} when ax <= bx -> {v, [{ay, ax, bx} | h]}
      {{ax, ay}, {bx, ay}}, {v, h} -> {v, [{ay, bx, ax} | h]}
    end)
  end

  defp rectangle_valid?({ax, ay}, {bx, by}, coords, vertical_lines, horizontal_lines)
       when bx < ax do
    rectangle_valid?({bx, ay}, {ax, by}, coords, vertical_lines, horizontal_lines)
  end

  defp rectangle_valid?({ax, ay}, {bx, by}, coords, vertical_lines, horizontal_lines)
       when by < ay do
    rectangle_valid?({ax, by}, {bx, ay}, coords, vertical_lines, horizontal_lines)
  end

  defp rectangle_valid?({ax, ay} = a, {bx, by} = b, coords, vertical_lines, horizontal_lines) do
    corners = [{ax, ay}, {ax, by}, {bx, by}, {bx, ay}]

    corners_in_polygon?(corners, coords, vertical_lines) and
      within_horizontal_lines?(a, b, horizontal_lines) and
      within_vertical_lines?(a, b, vertical_lines)
  end

  defp corners_in_polygon?(corners, coords, vertical_lines),
    do:
      Enum.all?(
        corners,
        &(MapSet.member?(coords, &1) or point_in_polygon?(&1, vertical_lines))
      )

  defp within_horizontal_lines?(_, _, []), do: true

  defp within_horizontal_lines?({ax, ay}, {bx, by}, [{y, sx, ex} | _])
       when y in (ay + 1)..(by - 1)//1 and ex > ax and sx < bx,
       do: false

  defp within_horizontal_lines?(a, b, [_ | rest]), do: within_horizontal_lines?(a, b, rest)

  defp within_vertical_lines?(_, _, []), do: true

  defp within_vertical_lines?({ax, ay}, {bx, by}, [{x, sy, ey} | _])
       when x in (ax + 1)..(bx - 1)//1 and ey > ay and sy < by,
       do: false

  defp within_vertical_lines?(a, b, [_ | rest]), do: within_vertical_lines?(a, b, rest)

  defp point_in_polygon?(coord, lines), do: point_in_polygon?(coord, lines, false)
  defp point_in_polygon?(_, [], inside), do: inside

  defp point_in_polygon?({x, y} = xy, [{px, ay, by} | rest], inside)
       when px > x and y in ay..(by - 1)//1,
       do: point_in_polygon?(xy, rest, not inside)

  defp point_in_polygon?(xy, [_ | rest], inside), do: point_in_polygon?(xy, rest, inside)

  defp area({ax, ay}, {bx, by}), do: (abs(ax - bx) + 1) * (abs(ay - by) + 1)
end

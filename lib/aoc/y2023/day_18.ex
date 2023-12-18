defmodule AOC.Y2023.Day18 do
  @moduledoc false
  use AOC.Solution

  require Integer

  @directions [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  @impl true
  def load_data() do
    Data.load_day(18)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn [dir, amt, "(#" <> <<hex::binary-6>> <> ")"] ->
      {dir, String.to_integer(amt), hex}
    end)
  end

  @impl true
  def part_one(data) do
    solve(data)
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn {_, _, <<v::binary-5>> <> w = hex} ->
      amt = String.to_integer(v, 16)

      dir =
        case w do
          "0" -> "R"
          "1" -> "D"
          "2" -> "L"
          "3" -> "U"
        end

      {dir, amt, hex}
    end)
    |> solve()
  end

  defp solve(instructions) do
    # Corners represent both L and 7 corners (like day 10)
    # These are formed when we move from D to R (L) or L to U (L) or R to D (7) or U to L (7)
    corner_points =
      instructions
      |> Enum.with_index()
      |> Enum.zip(instructions |> Enum.with_index() |> Enum.slice(1..-1))
      |> Enum.filter(fn {{{f, _, _}, _}, {{t, _, _}, _}} ->
        (f == "D" and t == "R") or
          (f == "L" and t == "U") or
          (f == "R" and t == "D") or
          (f == "U" and t == "L")
      end)
      |> Enum.map(fn {{_, i}, _} -> i end)

    lines = dig(instructions)

    corners =
      MapSet.new(corner_points, fn i ->
        {_, r..c} = Enum.at(lines, i)
        {r, c}
      end)
      |> IO.inspect()

    {row_min, row_max} = General.flat_map_min_max(lines, fn {fr..tr, _} -> [fr, tr] end)
    {col_min, col_max} = General.flat_map_min_max(lines, fn {_, fc..tc} -> [fc, tc] end)

    flood_fill(
      [{0, 0}],
      lines,
      {row_min, row_max},
      {col_min, col_max},
      corners,
      MapSet.new([{0, 0}])
    )
  end

  defp on_polygon?(polygon, {r, c}) do
    polygon
    |> Enum.find(fn {sr..er, sc..ec} ->
      r >= sr and r <= er and c >= sc and c <= ec
    end)
    |> then(&(!is_nil(&1)))
  end

  defp inside?(polygon, {r, c}, m, n, corners) do
    {r, c}
    |> Stream.iterate(fn {a, b} -> {a + 1, b + 1} end)
    |> Stream.take_while(&in_range?(&1, m, n))
    |> Stream.filter(&on_polygon?(polygon, &1))
    |> Stream.filter(&(not MapSet.member?(corners, &1)))
    |> Enum.count()
    |> Integer.is_odd()
  end

  defp flood_fill([], _, _, _, _, visited) do
    MapSet.size(visited)
  end

  defp flood_fill(points, polygon, m, n, corners, visited) do
    points
    |> Enum.flat_map(fn {r, c} ->
      @directions
      |> Enum.map(fn {dr, dc} -> {r + dr, c + dc} end)
      |> Enum.reject(&MapSet.member?(visited, &1))
      |> Enum.filter(fn p ->
        on_polygon?(polygon, p) or inside?(polygon, p, m, n, corners)
      end)
    end)
    |> Enum.uniq()
    |> then(&flood_fill(&1, polygon, m, n, corners, MapSet.union(visited, MapSet.new(&1))))
  end

  defp in_range?({r, c}, {row_min, row_max}, {col_min, col_max}),
    do: r >= row_min and r <= row_max and c >= col_min and c <= col_max

  defp dig(instructions), do: dig(instructions, 0, 0, [])

  defp dig([], _, _, lines), do: lines

  defp dig([{"R", amt, _hex} | rest], r, c, lines),
    do: dig(rest, r, c + amt, lines ++ [{r..r, c..(c + amt)}])

  defp dig([{"L", amt, _hex} | rest], r, c, lines),
    do: dig(rest, r, c - amt, lines ++ [{r..r, (c - amt)..c}])

  defp dig([{"U", amt, _hex} | rest], r, c, lines),
    do: dig(rest, r - amt, c, lines ++ [{(r - amt)..r, c..c}])

  defp dig([{"D", amt, _hex} | rest], r, c, lines),
    do: dig(rest, r + amt, c, lines ++ [{r..(r + amt), c..c}])
end

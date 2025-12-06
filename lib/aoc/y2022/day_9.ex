defmodule AOC.Y2022.Day9 do
  @moduledoc false

  use AOC.Solution, year: 2022, day: 9

  @dir_mapping %{
    "R" => {1, 0},
    "L" => {-1, 0},
    "U" => {0, 1},
    "D" => {0, -1}
  }
  @start_pos {0, 0}

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [dir, dist] -> {dir, String.to_integer(dist)} end)
    |> Enum.flat_map(fn {dir, dist} -> for _ <- 1..dist, do: dir end)
  end

  @impl true
  def part_one(data, _opts) do
    move(data, 1)
  end

  @impl true
  def part_two(data, _opts) do
    move(data, 9)
  end

  defp connected?({hx, hy}, {tx, ty}), do: abs(hx - tx) <= 1 and abs(hy - ty) <= 1

  defp move(moves, tail_knots),
    do: move_many(moves, @start_pos, List.duplicate(@start_pos, tail_knots)) |> MapSet.size()

  defp move_many([], _head, _tails), do: MapSet.new([@start_pos])

  defp move_many([dir | rest], {hx, hy}, tails) do
    {hdx, hdy} = @dir_mapping[dir]
    new_head = {hx + hdx, hy + hdy}

    tails
    |> Enum.reduce([new_head], fn tail, [cur_head | _rest] = new_tails ->
      [try_keep_up(cur_head, tail) | new_tails]
    end)
    |> then(fn tails_with_head ->
      [head | new_tails] = Enum.reverse(tails_with_head)
      MapSet.put(move_many(rest, head, new_tails), List.last(new_tails))
    end)
  end

  defp try_keep_up(head, tail) do
    if connected?(head, tail), do: tail, else: keep_up(head, tail)
  end

  defp keep_up({hx, hy}, {tx, ty}) when hx == tx and hy > ty, do: {tx, ty + 1}
  defp keep_up({hx, hy}, {tx, ty}) when hx == tx and hy < ty, do: {tx, ty - 1}
  defp keep_up({hx, hy}, {tx, ty}) when hy == ty and hx > tx, do: {tx + 1, ty}
  defp keep_up({hx, hy}, {tx, ty}) when hy == ty and hx < tx, do: {tx - 1, ty}
  defp keep_up({hx, hy}, {tx, ty}) when hx > tx and hy > ty, do: {tx + 1, ty + 1}
  defp keep_up({hx, hy}, {tx, ty}) when hx > tx and hy < ty, do: {tx + 1, ty - 1}
  defp keep_up({hx, hy}, {tx, ty}) when hx < tx and hy > ty, do: {tx - 1, ty + 1}
  defp keep_up({hx, hy}, {tx, ty}) when hx < tx and hy < ty, do: {tx - 1, ty - 1}
end

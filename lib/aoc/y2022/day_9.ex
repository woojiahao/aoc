defmodule AOC.Y2022.Day9 do
  @moduledoc false

  use AOC.Solution

  @dir_mapping %{
    "R" => {1, 0},
    "L" => {-1, 0},
    "U" => {0, 1},
    "D" => {0, -1}
  }
  @start_pos {0, 0}

  @impl true
  def load_data() do
    Data.load_day(2022, 9)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [dir, dist] -> {dir, String.to_integer(dist)} end)
  end

  @impl true
  def part_one(data) do
    data
    |> move(@start_pos, @start_pos)
    |> MapSet.size()
  end

  @impl true
  def part_two(data) do
    data
    |> move_many(@start_pos, List.duplicate(@start_pos, 9))
    |> MapSet.size()
  end

  defp connected?({hx, hy}, {tx, ty}), do: abs(hx - tx) <= 1 and abs(hy - ty) <= 1

  defp move_many([], _head, _tails), do: MapSet.new([@start_pos])

  defp move_many([{dir, dist} | rest], {hx, hy}, tails) do
    {hdx, hdy} = @dir_mapping[dir]
    new_head = {hx + hdx * dist, hy + hdy * dist}

    tails
    |> Enum.reduce({[new_head], MapSet.new([])}, fn tail,
                                                    {[cur_head | _rest] = new_positions,
                                                     all_tail_positions} ->
      cur_head |> IO.inspect(label: "current head")
      {new_tail, tail_positions} = move_tail(dir, cur_head, tail) |> IO.inspect(label: "moved")
      {[new_tail] ++ new_positions, MapSet.union(tail_positions, all_tail_positions)}
    end)
    |> then(fn {new_tails_with_head, tail_positions} ->
      [head | new_tails] = Enum.reverse(new_tails_with_head)
      new_tails |> IO.inspect(label: "new tails")
      tail_positions |> IO.inspect(label: "tail positions")
      MapSet.union(tail_positions, move_many(rest, head, new_tails))
    end)
  end

  defp move([], _head, _tail), do: MapSet.new([@start_pos])

  defp move([{dir, dist} | rest], {hx, hy}, tail) do
    {hdx, hdy} = @dir_mapping[dir]
    new_head = {hx + hdx * dist, hy + hdy * dist}
    {new_tail, tail_positions} = move_tail(dir, new_head, tail)
    MapSet.union(tail_positions, move(rest, new_head, new_tail))
  end

  defp move_tail(dir, {hnx, hny} = head, tail) do
    {hdx, hdy} = @dir_mapping[dir]
    # head |> IO.inspect(label: "head")
    # tail |> IO.inspect(label: "tail")

    if connected?(head, tail) do
      {tail, MapSet.new([])}
    else
      new_tail = {hnx + -1 * hdx, hny + -1 * hdy}

      {new_tail,
       get_tail_path(dir, tail, new_tail, head)
       |> MapSet.new()}
    end
  end

  defp get_tail_path("U", {_tx, ty}, {_tnx, tny}, {hnx, _hny}),
    do: for(y <- (ty + 1)..tny, do: {hnx, y})

  defp get_tail_path("D", {_tx, ty}, {_tnx, tny}, {hnx, _hny}),
    do: for(y <- tny..(ty - 1), do: {hnx, y})

  defp get_tail_path("L", {tx, _ty}, {tnx, _tny}, {_hnx, hny}),
    do: for(x <- tnx..(tx - 1), do: {x, hny})

  defp get_tail_path("R", {tx, _ty}, {tnx, _tny}, {_hnx, hny}),
    do: for(x <- (tx + 1)..tnx, do: {x, hny})
end

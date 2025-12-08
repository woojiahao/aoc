defmodule AOC.Y2025.Day7 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 7

  @impl true
  def load_data(data, _opts) do
    {grid, m, n} =
      data
      |> String.split("\n")
      |> Data.parse_as_grid()

    tachyon_pos = grid |> Enum.find(fn {_, v} -> v == "S" end) |> elem(0)

    splitters =
      grid
      |> Enum.filter(fn {_, v} -> v == "^" end)
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    1..(m - 1)
    |> Enum.reduce({%{tachyon_pos => 1}, 0}, fn row, {beams, splits} ->
      {new_beams, add_splits} = calculate_beams(beams, splitters, row)
      {new_beams, splits + add_splits}
    end)
  end

  @impl true
  def part_one({_, splits}, _opts) do
    splits
  end

  @impl true
  def part_two({beams, _}, _opts) do
    Enum.sum_by(beams, fn {_, f} -> f end)
  end

  defp calculate_beams(cur_beams, splitters, row),
    do: calculate_beams(cur_beams, splitters, row, %{}, 0)

  defp calculate_beams(cur_beams, _, _, beams, splits) when map_size(cur_beams) == 0,
    do: {beams, splits}

  defp calculate_beams(cur_beams, splitters, row, beams, splits) do
    {{{_, c}, f}, tail} = AOCMap.hd(cur_beams)

    keys =
      if MapSet.member?(splitters, {row, c}),
        do: [{row, c - 1}, {row, c + 1}],
        else: [{row, c}]

    new_split =
      if MapSet.member?(splitters, {row, c}),
        do: splits + 1,
        else: splits

    new_beams = Enum.reduce(keys, beams, fn key, acc -> Map.update(acc, key, f, &(&1 + f)) end)

    calculate_beams(tail, splitters, row, new_beams, new_split)
  end
end

defmodule AOC.Y2022.Day6 do
  @moduledoc false

  use AOC.Solution, year: 2022, day: 6

  @window_size_1 4
  @window_size_2 14

  @impl true
  def load_data(data, _opts) do
    data |> String.split("\n") |> hd() |> String.graphemes()
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.with_index()
    |> Enum.reduce_while(%{}, fn
      {v, idx}, win when idx < @window_size_1 ->
        {:cont, Map.put(win, v, Map.get(win, v, 0) + 1)}

      {v, idx}, win ->
        out = Enum.at(data, idx - @window_size_1)

        if out == v do
          {:cont, win}
        else
          updated_win =
            win
            |> Map.put(v, Map.get(win, v, 0) + 1)
            |> Map.put(out, max(0, Map.get(win, out, 0) - 1))

          if Enum.all?(updated_win, &(elem(&1, 1) <= 1)) do
            {:halt, idx + 1}
          else
            {:cont, updated_win}
          end
        end
    end)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.with_index()
    |> Enum.reduce_while(%{}, fn
      {v, idx}, win when idx < @window_size_2 ->
        {:cont, Map.put(win, v, Map.get(win, v, 0) + 1)}

      {v, idx}, win ->
        out = Enum.at(data, idx - @window_size_2)

        if out == v do
          {:cont, win}
        else
          updated_win =
            win
            |> Map.put(v, Map.get(win, v, 0) + 1)
            |> Map.put(out, max(0, Map.get(win, out, 0) - 1))

          if Enum.all?(updated_win, &(elem(&1, 1) <= 1)) do
            {:halt, idx + 1}
          else
            {:cont, updated_win}
          end
        end
    end)
  end
end

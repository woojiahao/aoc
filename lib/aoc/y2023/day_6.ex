defmodule AOC.Y2023.Day6 do
  @moduledoc false

  use AOC.Solution, year: 2023, day: 6

  @impl true
  def load_data(data, _opts) do
    ["Time:" <> time, "Distance:" <> distance] = data |> String.split("\n")
    Enum.zip(parse_row(time), parse_row(distance))
  end

  defp parse_row(row),
    do:
      row
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.map(&ways_to_win/1)
    |> Enum.product()
  end

  @impl true
  def part_two(data, _opts) do
    ["Time:" <> time, "Distance:" <> distance] = data |> String.split("\n")
    time = time |> String.replace(" ", "") |> String.to_integer()
    distance = distance |> String.replace(" ", "") |> String.to_integer()
    ways_to_win({time, distance})
  end

  defp ways_to_win({t, d}), do: ways_to_win_max(1, t, t, d) - ways_to_win_min(1, t, t, d) + 1

  defp ways_to_win_min(l, r, _t, _d) when l >= r, do: l

  defp ways_to_win_min(l, r, t, d) when (l + div(r - l, 2)) * (t - (l + div(r - l, 2))) > d,
    do: ways_to_win_min(l, l + div(r - l, 2), t, d)

  defp ways_to_win_min(l, r, t, d),
    do: ways_to_win_min(l + div(r - l, 2) + 1, r, t, d)

  defp ways_to_win_max(l, r, _t, _d) when l >= r, do: l

  defp ways_to_win_max(l, r, t, d)
       when (l + trunc(ceil((r - l) / 2))) * (t - (l + trunc(ceil((r - l) / 2)))) > d,
       do: ways_to_win_max(l + trunc(ceil((r - l) / 2)), r, t, d)

  defp ways_to_win_max(l, r, t, d),
    do: ways_to_win_max(l, l + trunc(ceil((r - l) / 2)) - 1, t, d)
end

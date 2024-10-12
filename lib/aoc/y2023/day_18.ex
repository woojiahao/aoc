defmodule AOC.Y2023.Day18 do
  @moduledoc """
  Interesting day. First part could be solved by trying flood fill directly, checking if the
  points should be filled by using the raycasting technique from day 10.

  Second day cannot be bruteforced so must solve using shoelace formula (finding the area within
  the polygon) and then adding to half the perimeter + 1 (pick's theorem)
  """
  use AOC.Solution

  require Integer

  @directions %{
    "U" => {-1, 0},
    "D" => {1, 0},
    "L" => {0, -1},
    "R" => {0, 1}
  }

  @impl true
  def load_data() do
    Data.load_day(2023, 18)
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
    {vertices, perimeter} = dig(instructions)
    shoelace(vertices) + div(perimeter, 2) + 1
  end

  defp shoelace(vertices) do
    vertices
    |> General.zip_neighbor()
    |> General.map_sum(fn {{a, b}, {c, d}} ->
      a * d - b * c
    end)
    |> abs()
    |> div(2)
  end

  defp dig(instructions), do: dig(instructions, 0, 0, [{0, 0}], 0)

  defp dig([], _, _, vertices, perimeter), do: {vertices, perimeter}

  defp dig([{dir, amt, _hex} | rest], r, c, vertices, perimeter) do
    nr = r + elem(@directions[dir], 0) * amt
    nc = c + elem(@directions[dir], 1) * amt
    dig(rest, nr, nc, vertices ++ [{nr, nc}], perimeter + amt)
  end
end

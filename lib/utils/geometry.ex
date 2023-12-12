defmodule Utils.Geometry do
  @moduledoc """
  Simple geometry tools.
  """
  require Integer

  def in_range?({x, y}, m, n), do: x >= 0 and x < m and y >= 0 and y < n

  @doc """
  Performs even-odd rule raycasting to check if point is within polygon. Draws a diagonal line
  towards the bottom right.

  corner? used to filter out paths that are corners (meaning that the ray is passing through a
  new "wall")
  """
  @spec in_polygon?(
          MapSet.t({integer(), integer()}),
          ({integer(), integer()} -> boolean()),
          integer(),
          integer(),
          integer(),
          integer()
        ) :: boolean()
  def in_polygon?(polygon, corner?, x, y, m, n) do
    {x, y}
    |> Stream.iterate(fn {a, b} -> {a + 1, b + 1} end)
    |> Stream.take_while(&in_range?(&1, m, n))
    |> Stream.filter(&MapSet.member?(polygon, &1))
    |> Stream.filter(&corner?.(&1))
    |> Enum.count()
    |> Integer.is_odd()
  end
end

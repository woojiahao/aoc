defmodule Utils.Math do
  @moduledoc """
  Common math functions
  """

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))

  def lcm([]), do: 0
  def lcm([a]), do: a
  def lcm([a, b]), do: lcm(a, b)
  def lcm([a, b | rest]), do: Enum.reduce(rest, lcm(a, b), &lcm(&1, &2))

  def inf, do: :math.pow(10, 10)

  def manhattan({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def euclidean({x1, y1}, {x2, y2}),
    do: :math.pow(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2), 0.5)

  def euclidean({x1, y1, z1}, {x2, y2, z2}),
    do: :math.pow(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2), 0.5)

  def euclidean(a, b),
    do:
      Enum.zip(a, b)
      |> Enum.sum_by(fn {x, y} -> :math.pow(x - y, 2) end)
      |> :math.pow(0.5)

  def mod(a, n), do: rem(rem(a, n) + n, n)

  def sign(n) when n == 0, do: 0
  def sign(n) when n < 0, do: -1
  def sign(_), do: 1

  def xor(a, b), do: Bitwise.bxor(a, b)

  def ipow(a, b), do: :math.pow(a, b) |> trunc()
end

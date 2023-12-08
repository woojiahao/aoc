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
end

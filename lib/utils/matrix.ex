defmodule Utils.Matrix do
  @moduledoc """
  Treats matrices as a map of coordinates instead.
  """

  @enforce_keys [:m, :n, :data]
  defstruct [:m, :n, :data]

  def new(m, n, _) when m <= 0 or n <= 0, do: raise("m and n must be greater 0.")

  def new(m, n, default) do
    %Utils.Matrix{
      m: m,
      n: n,
      data: make_data(m - 1, n - 1, default)
    }
  end

  def new(m, n), do: new(m, n, nil)

  defp transpose_helper(m, n, _matrix) when m < 0 or n < 0, do: %{}

  defp transpose_helper(m, n, matrix) do
    %{{m, n} => get(matrix, n, m)}
    |> Map.merge(transpose_helper(m - 1, n, matrix))
    |> Map.merge(transpose_helper(m, n - 1, matrix))
    |> Map.merge(transpose_helper(m - 1, n - 1, matrix))
  end

  def transpose(%{m: m, n: n} = matrix),
    do: %Utils.Matrix{m: n, n: m, data: transpose_helper(n - 1, m - 1, matrix)}

  def get(_matrix, r, _c) when r < 0, do: raise("r < 0 not allowed.")
  def get(_matrix, _r, c) when c < 0, do: raise("c < 0 not allowed.")
  def get(%{m: m} = _matrix, r, _c) when r >= m, do: raise("r >= m not allowed.")
  def get(%{n: n} = _matrix, _r, c) when c >= n, do: raise("c >= n not allowed.")
  def get(%{data: cur} = _matrix, r, c), do: Map.get(cur, {r, c})

  def set(_matrix, r, _c, _value) when r < 0, do: raise("r < 0 not allowed.")
  def set(_matrix, _r, c, _value) when c < 0, do: raise("c < 0 not allowed.")
  def set(%{m: m} = _matrix, r, _c, _value) when r >= m, do: raise("r >= m not allowed.")
  def set(%{n: n} = _matrix, _r, c, _value) when c >= n, do: raise("c >= n not allowed.")

  def set(%{m: m, n: n, data: cur} = _matrix, r, c, value),
    do: %Utils.Matrix{m: m, n: n, data: Map.update!(cur, {r, c}, fn _old -> value end)}

  def print(%{m: m, n: n, data: data} = matrix) do
    for i <- 0..(m - 1) do
      data
      |> Enum.filter(fn {{r, _c}, _v} -> r == i end)
      |> Enum.sort_by(fn {{_r, c}, _v} -> c end)
      |> Enum.map_join("\t", fn {_, v} -> v end)
      |> IO.puts()

      IO.puts("")
    end

    matrix
  end

  defp make_data(m, n, _value) when m < 0 or n < 0, do: %{}

  defp make_data(m, n, value) do
    %{{m, n} => value}
    |> Map.merge(make_data(m - 1, n, value))
    |> Map.merge(make_data(m, n - 1, value))
    |> Map.merge(make_data(m - 1, n - 1, value))
  end
end

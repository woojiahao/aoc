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

  # def from(arr) do
  #   rows = length(raw_data)
  #   cols = length(Enum.at(raw_data, 0))

  #   from_helper(0, 0, arr, %Utils.Matrix{
  #     m: rows,
  #     n: cols,
  #     data: make_data(rows - 1, cols - 1, nil)
  #   })
  # end

  # defp from_helper(row, col, _arr, %Utils.Matrix{m: m, n: n})
  #      when row < 0 or col < 0 or row >= m or col >= n do
  #   %{}
  # end

  # defp from_helper(row, col, arr, %Utils.Matrix{data: data}) do
  # end

  defp transpose_helper(m, n, _matrix) when m < 0 or n < 0, do: %{}

  defp transpose_helper(m, n, matrix) do
    %{{m, n} => get(matrix, n, m)}
    |> Map.merge(transpose_helper(m - 1, n, matrix))
    |> Map.merge(transpose_helper(m, n - 1, matrix))
    |> Map.merge(transpose_helper(m - 1, n - 1, matrix))
  end

  def transpose(%{m: m, n: n} = matrix),
    do: %Utils.Matrix{m: n, n: m, data: transpose_helper(n - 1, m - 1, matrix)}

  # defp matmul(r, c, %{m: m} = matrix, %{n: n} = other) when r >= m or c >= n, do: %{}

  # defp matmul_helper(r, c, %{m: m} = matrix, %{n: n} = other) do
  # Enum.reduce(0..(n-1), 0.0, fn col ->

  # end)
  # for col <- 0..n do
  #   for row <- 0..n do
  #     acc += get(matrix, )
  #   end
  # end
  # end

  # def matmul(%{m: m1, n: n1} = matrix, %{m: m2, n: n2} = other) when n1 != m2,
  #   do: raise("#{m1} x #{n1} matrix cannot multiply by #{m2} x #{n2} matrix.")

  # def matmul(%{m: m} = matrix, %{n: n} = other) do
  #   %Utils.Matrix{m: m, n: n, data: matmul_helper(0, 0, matrix, other)}
  # end

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

  def print(%{m: m, n: _n, data: data} = matrix) do
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

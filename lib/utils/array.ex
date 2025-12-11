defmodule Utils.Array do
  @moduledoc false

  def transpose(arr) do
    arr
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def from_matrix_to_coord_map([]), do: %{}

  def from_matrix_to_coord_map(matrix) do
    m = length(matrix)
    n = length(Enum.at(matrix, 0))

    for i <- 0..(m - 1) do
      for j <- 0..(n - 1) do
        {{i, j}, matrix |> Enum.at(i) |> Enum.at(j)}
      end
    end
    |> Enum.flat_map(& &1)
    |> Map.new()
  end

  def array_at(array, at), do: :array.get(at, array)
end

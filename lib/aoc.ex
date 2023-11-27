defmodule AOC do
  @moduledoc """
  Documentation for `AOC`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> AOC.hello()
      :world

  """
  def hello do
    Utils.Matrix.new(5, 4, 5)
    |> Utils.Matrix.set(2, 3, 15)
    |> Utils.Matrix.print()
    |> Utils.Matrix.transpose()
    |> Utils.Matrix.print()
  end
end

defmodule Utils.General do
  @moduledoc """
  General utility for computing things quickly.
  """

  @doc """
  Performs a cyclic index increment based on size of a list.
  """
  def cyclic_index_next(i, lst), do: rem(i + 1, length(lst))

  @doc """
  Converts the first and last element of a list into a tuple.
  """
  def first_last_tuple([]), do: nil
  def first_last_tuple(lst), do: {List.first(lst), List.last(lst)}

  @doc """
  Prepends extra to list if predicate is true.
  """
  @spec prepend_if_true(list(), boolean(), list()) :: list()
  def prepend_if_true(list, predicate, extra) do
    if predicate do
      extra ++ list
    else
      list
    end
  end

  @doc """
  Partitions list into two parts of size [left_size | right_size].

  If left_size + right_size != length(list), error is raised.
  """
  def partition_list(list, left_size, right_size) when length(list) != left_size + right_size,
    do: raise("Invalid partition sizing")

  def partition_list(list, left_size, _right_size) do
    {Enum.slice(list, 0..(left_size - 1)), Enum.slice(list, left_size..-1)}
  end

  @doc """
  Generates all distinct pairs of elements of a list.
  """
  def distinct_pairs(list) do
    list = Enum.with_index(list)
    for {x, i} <- list, {y, j} <- list, j > i, do: {x, y}
  end

  def list_set_difference(first, second) do
    MapSet.new(first) |> MapSet.difference(MapSet.new(second))
  end
end

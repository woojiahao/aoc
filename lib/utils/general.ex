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

  @spec map_sum(list(any()), (any() -> number())) :: number()
  def map_sum(lst, map_fn) do
    lst
    |> Enum.map(&map_fn.(&1))
    |> Enum.sum()
  end

  def map_product(lst, map_fn) do
    lst
    |> Enum.map(&map_fn.(&1))
    |> Enum.product()
  end

  @spec map_max(list(any()), (any() -> number())) :: number()
  def map_max(lst, map_fn) do
    lst
    |> Enum.map(&map_fn.(&1))
    |> Enum.max()
  end

  @spec map_min(list(any()), (any() -> number())) :: number()
  def map_min(lst, map_fn) do
    lst
    |> Enum.map(&map_fn.(&1))
    |> Enum.min()
  end

  @spec map_min_max(list(any()), (any() -> number())) :: {number(), number()}
  def map_min_max(lst, map_fn) do
    lst
    |> Enum.map(&map_fn.(&1))
    |> Enum.min_max()
  end

  @spec flat_map_min_max(list(any()), (any() -> list(number()))) :: {number(), number()}
  def flat_map_min_max(lst, map_fn) do
    lst
    |> Enum.flat_map(&map_fn.(&1))
    |> Enum.min_max()
  end

  @spec zip_neighbor(list(any())) :: [{any(), any()}]
  def zip_neighbor(lst) do
    Enum.zip(lst, Enum.slice(lst, 1..-1//1))
  end

  @spec rows_count(list(list(any()))) :: integer()
  def rows_count(matrix), do: length(matrix)

  @spec cols_count(list(list(any()))) :: integer()
  def cols_count(matrix), do: matrix |> Enum.at(0) |> length()

  def merge_if(map, predicate, other) do
    if predicate do
      Map.merge(map, other)
    else
      map
    end
  end

  def generate_coord_list(m, n) do
    for i <- 0..(m - 1) do
      for j <- 0..(n - 1) do
        {i, j}
      end
    end
    |> Enum.flat_map(& &1)
  end

  def parse_space_delimited_matrix(data) do
    data
    |> String.split("\n")
    |> Enum.map(fn row -> Regex.split(~r/\s+/, row, trim: true) end)
  end
end

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

  @spec prepend_if_true(list(), boolean(), list()) :: list()
  def prepend_if_true(list, predicate, extra) do
    if predicate do
      extra ++ list
    else
      list
    end
  end
end

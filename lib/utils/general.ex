defmodule Utils.General do
  @moduledoc """
  General utility for computing things quickly.
  """

  def cyclic_index_next(i, lst), do: rem(i + 1, length(lst))
end

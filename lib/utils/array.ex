defmodule Utils.Array do
  @moduledoc false

  def transpose(arr) do
    arr
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def to_grid_string(arr) do
   
  end
end

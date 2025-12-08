defmodule Utils.Map do
  @moduledoc false

  def hd(map) do
    {key, value} = Enum.at(map, 0)
    tail = Map.delete(map, key)
    {{key, value}, tail}
  end
end

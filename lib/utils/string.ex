defmodule Utils.String do
  @moduledoc false

  @spec ord(binary()) :: integer()
  def ord(s) do
    :binary.first(s)
  end
end

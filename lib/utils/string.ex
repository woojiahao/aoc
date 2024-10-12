defmodule Utils.String do
  @moduledoc false

  def ord(s) do
    :binary.first(s)
  end
end

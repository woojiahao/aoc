defmodule Utils.String do
  @moduledoc false

  @spec ord(binary()) :: integer()
  def ord(s) do
    :binary.first(s)
  end

  def chunk_every(s, v) do
    String.split(s, ~r/.{#{v}}/, include_captures: true, trim: true)
  end
end

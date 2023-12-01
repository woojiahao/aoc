defmodule Utils.Data do
  @moduledoc false

  def load_day(day, split),
    do:
      Path.join([:code.priv_dir(:aoc), Integer.to_string(Date.utc_today().year), "day#{day}.txt"])
      |> File.read!()
      |> String.split(split)

  def load_day(day), do: load_day(day, "\n")
end

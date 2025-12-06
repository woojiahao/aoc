defmodule Utils.Data do
  @moduledoc false

  @spec load_day(integer(), integer(), boolean()) :: String.t()
  def load_day(year, day, true),
    do:
      Path.join([:code.priv_dir(:aoc), Integer.to_string(year), "day#{day}-test.txt"])
      |> File.read!()
      |> String.trim()

  def load_day(year, day, false),
    do:
      Path.join([:code.priv_dir(:aoc), Integer.to_string(year), "day#{day}.txt"])
      |> File.read!()
      |> String.trim()

  # @spec load_day(integer(), integer(), String.t()) :: any()
  # def load_day(year, day, split),
  #   do:
  #     Path.join([:code.priv_dir(:aoc), Integer.to_string(year), "day#{day}.txt"])
  #     |> File.read!()
  #     |> String.trim()
  #     |> String.split(split)
  #
  # def load_day(year, day), do: load_day(year, day, "\n")

  # def load_day_as_grid(year, day, line_delimiter \\ ""),
  #   do:
  #     load_day(year, day)
  #     |> Enum.map(&String.split(&1, line_delimiter, trim: true))
  #     |> then(&create_grid/1)
  #
  def parse_as_grid(data, line_delimiter \\ "") do
    data
    |> Enum.map(&String.split(&1, line_delimiter, trim: true))
    |> create_grid()
  end

  defp create_grid(points) do
    m = length(points)
    n = points |> Enum.at(0) |> length()

    grid =
      Enum.reduce(0..(m - 1), %{}, fn r, grid ->
        Map.new(0..(n - 1), fn c ->
          p = points |> Enum.at(r) |> Enum.at(c)
          {{r, c}, p}
        end)
        |> then(&Map.merge(grid, &1))
      end)

    {grid, m, n}
  end
end

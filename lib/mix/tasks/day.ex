defmodule Mix.Tasks.Day do
  @moduledoc """
  Runs a given day's solution for the given year.

  ## Options

    * `--test` - runs solution against test input

    * `--part` - the specific part of the day to test
  """

  use Mix.Task

  @switches [
    test: :boolean,
    part: :integer
  ]

  @default_opts [test: false, part: nil]

  def run(argv) do
    {opts, args} = OptionParser.parse!(argv, strict: @switches)
    opts = Keyword.merge(@default_opts, opts)
    part = Keyword.get(opts, :part)
    test = Keyword.get(opts, :test)

    if length(args) < 2 do
      raise "Provide a year and day"
    end

    [year, day] = args

    time_part(year, day, part, test)
  end

  @spec time_part(String.t(), String.t(), integer() | nil, boolean()) :: none()
  defp time_part(year, day, 1, test), do: time_part(year, day, 1, :solve_one, test)
  defp time_part(year, day, 2, test), do: time_part(year, day, 2, :solve_two, test)

  defp time_part(year, day, nil, test) do
    time_part(year, day, 1, test)
    time_part(year, day, 2, test)
  end

  @spec time_part(
          String.t(),
          String.t(),
          integer(),
          atom(),
          boolean()
        ) ::
          none()
  defp time_part(year, day, part, func, test) do
    IO.puts("===== YEAR #{year} DAY #{day} PART #{part} =====")
    module = "Elixir.AOC.Y#{year}.Day#{day}"
    before = :os.system_time(:millisecond)
    result = apply(String.to_atom(module), func, [test, part])
    now = :os.system_time(:millisecond)
    IO.puts("Result: #{inspect(result)}")
    IO.puts("Took: #{now - before}ms")
  end
end

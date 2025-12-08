defmodule AOC.Solution do
  @moduledoc false

  @callback load_data(data :: String.t(), opts :: %{test: boolean(), path: integer() | nil}) ::
              any()
  @callback part_one(data :: any(), opts :: %{test: boolean(), path: integer() | nil}) :: any()
  @callback part_two(data :: any(), opts :: %{test: boolean(), path: integer() | nil}) :: any()

  defmacro __using__(opts) do
    year = Keyword.get(opts, :year)
    day = Keyword.get(opts, :day)

    if is_nil(year) do
      raise "Provide year to load the solution"
    end

    if is_nil(day) do
      raise "Provide day to load the solution"
    end

    quote do
      alias Utils.{Array, Data, General, Geometry, Math, Matrix, Set}
      alias Utils.String, as: AOCString
      alias Utils.Map, as: AOCMap

      @behaviour AOC.Solution

      @year unquote(year)
      @day unquote(day)

      def solve_one(test, part) do
        Utils.Data.load_day(@year, @day, test)
        |> load_data(%{test: test, part: part})
        |> part_one(%{test: test, part: part})
      end

      def solve_two(test, part) do
        Utils.Data.load_day(@year, @day, test)
        |> load_data(%{test: test, part: part})
        |> part_two(%{test: test, part: part})
      end
    end
  end
end

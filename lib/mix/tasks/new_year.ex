defmodule Mix.Tasks.NewYear do
  @moduledoc """
  Generates a new year's worth of solution files and data files.

  ## Options

    * `--days` - specifies the number of days to generate
  """

  use Mix.Task

  @switches [
    days: :integer
  ]

  @default_opts [days: 25]

  @code_folder Path.join(File.cwd!(), "lib/aoc")
  @data_folder Path.join(File.cwd!(), "priv")

  def run(argv) do
    {opts, args} = OptionParser.parse!(argv, strict: @switches)

    case args do
      [year] ->
        [days: days] = Keyword.merge(@default_opts, opts)
        create_code_files(year, days)
        create_data_files(year, days)

      _ ->
        raise "Provide the year"
    end
  end

  @spec create_code_files(String.t(), integer()) :: none()
  defp create_code_files(year, days) do
    folder_path = Path.join(@code_folder, "y#{year}")
    File.mkdir(folder_path)

    for i <- 1..days do
      File.write(Path.join(folder_path, "day_#{i}.ex"), """
      defmodule AOC.Y#{year}.Day#{i} do
        @moduledoc false

        use AOC.Solution, year: #{year}, day: #{i}

        @impl true
        def load_data(data, _opts) do
          data
          |> String.split("\\n")
        end

        @impl true
        def part_one(_data, _opts) do
          :not_implemented
        end

        @impl true
        def part_two(_data, _opts) do
          :not_implemented
        end
      end
      """)
    end
  end

  @spec create_data_files(String.t(), integer()) :: none()
  defp create_data_files(year, days) do
    folder_path = Path.join(@data_folder, year)
    File.mkdir(folder_path)

    for i <- 1..days do
      File.touch(Path.join(folder_path, "day#{i}.txt"))
      File.touch(Path.join(folder_path, "day#{i}-test.txt"))
    end
  end
end

defmodule Mix.Tasks.NewYear do
  @moduledoc false

  use Mix.Task

  @code_folder Path.join(File.cwd!(), "lib/aoc")
  @data_folder Path.join(File.cwd!(), "priv")

  def run([]) do
    raise "Provide a year"
  end

  def run([year]) do
    create_code_files(year)
    create_data_files(year)
  end

  @spec create_code_files(String.t()) :: none()
  defp create_code_files(year) do
    folder_path = Path.join(@code_folder, "y#{year}")
    File.mkdir(folder_path)

    for i <- 1..25 do
      File.write(Path.join(folder_path, "day_#{i}.ex"), """
      defmodule AOC.Y#{year}.Day#{i} do
        @moduledoc false

        use AOC.Solution

        @impl true
        def load_data() do
          Data.load_day(#{i})
        end

        @impl true
        def part_one(data) do
          raise "Part 1 not implemented for #{year} day #{i}"
        end

        @impl true
        def part_two(data) do
          raise "Part 2 not implemented for #{year} day #{i}"
        end
      end
      """)
    end
  end

  @spec create_data_files(String.t()) :: none()
  defp create_data_files(year) do
    folder_path = Path.join(@data_folder, year)
    File.mkdir(folder_path)

    for i <- 1..25 do
      File.touch(Path.join(folder_path, "day#{i}.txt"))
    end
  end
end

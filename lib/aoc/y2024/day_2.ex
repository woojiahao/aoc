defmodule AOC.Y2024.Day2 do
  @moduledoc false

  use AOC.Solution, year: 2024, day: 2

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  @impl true
  def part_one(data, _opts) do
    Enum.count(data, &safe?/1)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.count(fn row ->
      0..(length(row) - 1) |> Enum.map(&List.delete_at(row, &1)) |> Enum.any?(&safe?/1)
    end)
  end

  defp get_pattern([a | [b | _]]) when a > b, do: &Kernel.>/2
  defp get_pattern([a | [b | _]]) when a < b, do: &Kernel.</2
  defp get_pattern(_), do: &Kernel.==/2

  defp safe?(row) do
    pattern = get_pattern(row)

    General.zip_neighbor(row)
    |> Enum.all?(fn {a, b} -> pattern.(a, b) and abs(a - b) in 1..3 end)
  end
end

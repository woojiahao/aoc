defmodule AOC.Y2025.Day6 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 6

  @impl true
  def load_data(data, _opts) do
    [operations | numbers_reversed] =
      data
      |> String.split("\n")
      |> Enum.reverse()

    {operations, Enum.reverse(numbers_reversed)}
  end

  @impl true
  def part_one({operations, numbers}, _opts) do
    numbers
    |> Enum.map(
      &(String.split(&1, ~r/\s+/, trim: true)
        |> Enum.map(fn v -> String.to_integer(v) end))
    )
    |> Matrix.transpose()
    |> run_operations(operations)
  end

  @impl true
  def part_two({operations, numbers}, _opts) do
    numbers
    |> Enum.map(&String.graphemes/1)
    |> Matrix.transpose()
    |> Enum.chunk_while(
      [],
      fn el, acc ->
        if Enum.all?(el, &(&1 == " ")),
          do: {:cont, acc, []},
          else: {:cont, [el |> Enum.join() |> String.trim() |> String.to_integer() | acc]}
      end,
      fn
        [] -> {:cont, []}
        acc -> {:cont, acc, []}
      end
    )
    |> run_operations(operations)
  end

  defp run_operations(numbers, operations) do
    numbers
    |> Enum.zip(String.split(operations, ~r/\s+/, trim: true))
    |> Enum.sum_by(fn
      {nums, "+"} -> Enum.sum(nums)
      {nums, "*"} -> Enum.product(nums)
    end)
  end
end

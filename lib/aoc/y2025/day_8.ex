defmodule AOC.Y2025.Day8 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 8

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&Enum.map(&1, fn v -> String.to_integer(v) end))
  end

  @impl true
  def part_one(data, %{test: test}) do
    ordered_pairs(data)
    |> Enum.take(pick(test))
    |> Enum.reduce(UFDS.new(length(data)), fn {i, j, _, _, _}, acc -> UFDS.union(acc, i, j) end)
    |> UFDS.union_sizes()
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.take(3)
    |> Enum.product_by(&elem(&1, 1))
  end

  @impl true
  def part_two(data, _opts) do
    ordered_pairs(data)
    |> Enum.reduce_while(
      {UFDS.new(length(data)), -1, -1},
      fn {i, j, [x | _], [y | _], _}, {acc, _, _} ->
        acc = UFDS.union(acc, i, j)
        if acc.unions == 1, do: {:halt, {acc, x, y}}, else: {:cont, {acc, -1, -1}}
      end
    )
    |> then(fn {_, x, y} -> x * y end)
  end

  defp pick(true), do: 10
  defp pick(_), do: 1000

  @spec ordered_pairs([[integer()]]) :: [
          {integer(), integer(), [integer()], [integer()], float()}
        ]
  defp ordered_pairs(data) do
    n = length(data)

    for i <- 0..(n - 1)//1,
        j <- (i + 1)..(n - 1)//1 do
      di = Enum.at(data, i)
      dj = Enum.at(data, j)
      {i, j, di, dj, Math.euclidean(di, dj)}
    end
    |> Enum.sort_by(&elem(&1, 4))
  end
end

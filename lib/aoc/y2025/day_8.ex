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
    |> Enum.reduce(UFDS.new(length(data)), fn {_, i, j, _, _}, acc -> UFDS.union(acc, i, j) end)
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
      fn {_, i, j, [x | _], [y | _]}, {acc, _, _} ->
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
    start = :os.system_time(:millisecond)
    n = length(data)
    vec = :array.from_list(data)

    res =
      for i <- 0..(n - 1)//1,
          j <- (i + 1)..(n - 1)//1 do
        di = :array.get(i, vec)
        dj = :array.get(j, vec)

        {Math.euclidean(di, dj), i, j, di, dj}
      end
      |> Enum.sort()

    e = :os.system_time(:millisecond)
    IO.inspect(e - start, label: "creating the ordered pairs took")
    res
  end
end

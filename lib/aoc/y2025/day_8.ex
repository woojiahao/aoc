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
    Enum.reduce(1..pick(test), {ordered_pairs(data), UFDS.new(length(data))}, fn _, {h, u} ->
      {h, {_, i, j, _, _}} = Heap.pop(h)
      {h, UFDS.union(u, i, j)}
    end)
    |> elem(1)
    |> UFDS.union_sizes()
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.take(3)
    |> Enum.product_by(&elem(&1, 1))
  end

  @impl true
  def part_two(data, _opts) do
    operation(UFDS.new(length(data)), ordered_pairs(data))
  end

  @spec operation(UFDS.t(), Heap.t()) :: integer()
  defp operation(ufds, heap) do
    {heap, {_, i, j, [x | _], [y | _]}} = Heap.pop(heap)
    ufds = UFDS.union(ufds, i, j)
    if ufds.unions == 1, do: x * y, else: operation(ufds, heap)
  end

  defp pick(true), do: 10
  defp pick(_), do: 1000

  @spec ordered_pairs([[integer()]]) :: Heap.t()
  defp ordered_pairs(data) do
    n = length(data)
    vec = :array.from_list(data)

    res =
      for i <- 0..(n - 1)//1,
          j <- (i + 1)..(n - 1)//1 do
        di = :array.get(i, vec)
        dj = :array.get(j, vec)

        {Math.euclidean(di, dj), i, j, di, dj}
      end
      |> Heap.from_list(&(elem(&1, 0) < elem(&2, 0)))

    res
  end
end

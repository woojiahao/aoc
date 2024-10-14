defmodule AOC.Y2022.Day13 do
  @moduledoc false

  use AOC.Solution
  import Utils.General, [:map_sum, :map_product]

  @dividers [[[[2]]], [[[6]]]]

  @impl true
  def load_data() do
    Data.load_day(2022, 13, "\n\n")
    |> Enum.map(fn pair ->
      pair |> String.split("\n") |> Enum.map(&Code.eval_string(&1)) |> Enum.map(&elem(&1, 0))
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.with_index(1)
    |> Enum.filter(fn {[a, b], _idx} -> compare(a, b) == :lt end)
    |> map_sum(fn {_data, idx} -> idx end)
  end

  @impl true
  def part_two(data) do
    @dividers
    |> Kernel.++(data)
    |> Enum.flat_map(& &1)
    |> Enum.sort(fn a, b -> compare(a, b) in [:lt, :eq] end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {v, _idx} -> v == [[2]] or v == [[6]] end)
    |> map_product(fn {_v, idx} -> idx end)
  end

  defp compare([], []), do: :eq
  defp compare([], _r), do: :lt
  defp compare(_l, []), do: :gt

  defp compare([l | lr], [r | rr]) when is_integer(l) and is_integer(r) do
    cond do
      l < r -> :lt
      l > r -> :gt
      true -> compare(lr, rr)
    end
  end

  defp compare([l | lr], [r | rr]) do
    case compare(List.wrap(l), List.wrap(r)) do
      :eq -> compare(lr, rr)
      v -> v
    end
  end
end

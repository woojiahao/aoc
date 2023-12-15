defmodule AOC.TwentyTwentyThree.Day15 do
  @moduledoc false
  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(15)
    |> List.first()
    |> String.split(",", trim: true)
  end

  @impl true
  def part_one(data) do
    data |> General.map_sum(&hash/1)
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(&String.reverse/1)
    |> Enum.map(fn
      "-" <> label -> {String.reverse(label), -1}
      <<length::binary-1>> <> "=" <> label -> {String.reverse(label), String.to_integer(length)}
    end)
    |> Enum.map(fn {label, length} -> {label, hash(label), length} end)
    |> sequence(List.duplicate([], 256))
    |> Enum.with_index()
    |> General.map_sum(
      &(elem(&1, 0)
        |> Enum.with_index()
        |> General.map_sum(fn {{_, length}, j} -> (elem(&1, 1) + 1) * (j + 1) * length end))
    )
  end

  defp hash(s), do: hash(s, 0)
  defp hash("", acc), do: acc
  defp hash(<<v::utf8>> <> rest, acc), do: hash(rest, rem((acc + v) * 17, 256))

  defp sequence([], boxes), do: boxes

  defp sequence([{label, h, -1} | rest], boxes) do
    box = Enum.at(boxes, h)
    idx = Enum.find_index(box, &(elem(&1, 0) == label))
    updated_box = if is_nil(idx), do: box, else: List.delete_at(box, idx)
    sequence(rest, List.replace_at(boxes, h, updated_box))
  end

  defp sequence([{label, h, length} | rest], boxes) do
    box = Enum.at(boxes, h)
    idx = Enum.find_index(box, &(elem(&1, 0) == label))

    updated_box =
      if is_nil(idx),
        do: box ++ [{label, length}],
        else: List.replace_at(box, idx, {label, length})

    sequence(rest, List.replace_at(boxes, h, updated_box))
  end
end

defmodule AOC.Y2025.Day1 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 1

  @start 50
  @dial_size 100

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(fn
      "L" <> l -> -1 * String.to_integer(l)
      "R" <> r -> String.to_integer(r)
    end)
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.reduce({@start, 0}, fn r, {acc, c} ->
      Math.mod(acc + r, @dial_size)
      |> then(&if &1 == 0, do: {&1, c + 1}, else: {&1, c})
    end)
    |> elem(1)
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.reduce({@start, 0}, fn r, {acc, c} ->
      full_rotations = div(abs(r), @dial_size)
      excess = Math.sign(r) * (abs(r) - full_rotations * @dial_size)
      new_acc = Math.mod(acc + excess, @dial_size)

      excess_past_zero =
        acc != 0 and new_acc != 0 and ((r < 0 and new_acc > acc) or (r > 0 and new_acc < acc))

      new_c = c + full_rotations + Enum.count([excess_past_zero, new_acc == 0], & &1)
      {new_acc, new_c}
    end)
    |> elem(1)
  end
end

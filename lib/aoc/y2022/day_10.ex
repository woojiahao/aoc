defmodule AOC.Y2022.Day10 do
  @moduledoc false

  use AOC.Solution
  import Utils.Math, [:inf]
  import Utils.General, [:map_sum]

  @target_cycles [20, 60, 100, 140, 180, 220]

  @impl true
  def load_data() do
    Data.load_day(2022, 10)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn
      ["addx", v] -> {:addx, String.to_integer(v)}
      ["noop"] -> {:noop}
    end)
    |> Enum.reduce([{1, 1}], fn
      {:noop}, [{cycle, x} | _rest] = acc -> [{cycle + 1, x} | acc]
      {:addx, v}, [{cycle, x} | _rest] = acc -> [{cycle + 2, x + v} | acc]
    end)
    |> Enum.reverse()
  end

  @impl true
  def part_one(data) do
    @target_cycles
    |> map_sum(fn cycle -> cycle * find_signal_strength(data, cycle) end)
  end

  @impl true
  def part_two(data) do
    draw_crt(data)
  end

  defp draw_crt(data),
    do: draw(data, 1, []) |> Enum.map_join("\n", fn row -> Enum.join(row, "") end)

  defp draw(_data, 241, crt), do: Enum.reverse(crt)

  defp draw(data, cycle, crt)
       when rem(cycle - 1, 40) == 0 and length(crt) == div(cycle - 1, 40) do
    draw(data, cycle, [[] | crt])
  end

  defp draw(data, cycle, [row | rest]) do
    strength = find_signal_strength(data, cycle)
    crt_pixel_idx = rem(cycle - 1, 40) + 1
    diff = crt_pixel_idx - strength
    crt_pixel = if diff >= 0 and diff <= 2, do: "#", else: "."
    draw(data, cycle + 1, [row ++ [crt_pixel] | rest])
  end

  defp find_signal_strength(data, strength),
    do: find_signal_strength(data, strength, 0, length(data) - 1)

  defp find_signal_strength(data, strength, l, r) when l >= r do
    potential = data |> Enum.at(l) |> elem(0)

    if potential > strength do
      inf()
    else
      data |> Enum.at(l) |> elem(1)
    end
  end

  defp find_signal_strength(data, strength, l, r) do
    m = l + div(r - l, 2) + 1
    potential = Enum.at(data, m)

    if elem(potential, 0) <= strength do
      find_signal_strength(data, strength, m, r)
    else
      find_signal_strength(data, strength, l, m - 1)
    end
  end
end

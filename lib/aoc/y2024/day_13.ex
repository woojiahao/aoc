defmodule AOC.Y2024.Day13 do
  @moduledoc false

  use AOC.Solution
  use Agent
  import Utils.Math

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @impl true
  def load_data() do
    Data.load_day(2024, 13, "\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(fn
      [
        button_a,
        button_b,
        prize
      ] ->
        {
          parse_regex_int(~r/^Button A: X\+(\d+), Y\+(\d+)$/, button_a),
          parse_regex_int(~r/^Button B: X\+(\d+), Y\+(\d+)$/, button_b),
          parse_regex_int(~r/^Prize: X=(\d+), Y=(\d+)$/, prize)
        }
    end)
  end

  @impl true
  def part_one(machines) do
    start_link()

    machines
    |> Enum.map(fn machine ->
      Agent.update(__MODULE__, fn _ -> %{} end)
      win(machine, 0, 0)
    end)
    |> Enum.reject(fn score -> score == Math.inf() end)
    |> Enum.sum()
  end

  @impl true
  def part_two(machines) do
    start_link()

    machines
    |> Enum.map(fn {a, b, [p_x, p_y]} ->
      {a, b, [p_x + 10_000_000_000_000, p_y + 10_000_000_000_000]}
    end)
    |> Enum.slice(1..1)
    |> Enum.map(fn machine ->
      Agent.update(__MODULE__, fn _ -> %{} end)
      win(machine, 0, 0)
    end)
    |> Enum.reject(fn score -> score == Math.inf() end)
    |> Enum.sum()
  end

  defp win({[a_x, a_y], [b_x, b_y], [p_x, p_y]}, a, b)
       when a * a_x + b * b_x > p_x or a * a_y + b * b_y > p_y do
    Math.inf()
  end

  defp win({[a_x, a_y], [b_x, b_y], [p_x, p_y]}, a, b)
       when a * a_x + b * b_x == p_x and a * a_y + b * b_y == p_y,
       do: a * 3 + b

  defp win({[a_x, a_y], [b_x, b_y], [p_x, p_y]} = machine, a, b) do
    cached_value = Agent.get(__MODULE__, fn memo -> memo[{a, b}] end)
    # {a, b} |> IO.inspect()

    if is_nil(cached_value) do
      v = min(win(machine, a + 1, b), win(machine, a, b + 1))
      Agent.update(__MODULE__, fn memo -> Map.put(memo, {a, b}, v) end)
      v
    else
      cached_value
    end
  end

  defp parse_regex_int(regex, text) do
    Regex.scan(regex, text, capture: :all_but_first)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end

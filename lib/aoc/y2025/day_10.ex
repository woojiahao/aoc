defmodule AOC.Y2025.Day10 do
  @moduledoc false

  use AOC.Solution, year: 2025, day: 10

  @type indicator_light_diagram :: integer()
  @type button_wiring_schematic :: [integer()]
  @type button_wiring_schematic_number :: integer()
  @type joltage_requirement :: [integer()]
  @type machine :: %{
          indicator_light_diagram: indicator_light_diagram(),
          button_wirings: [button_wiring_schematic()],
          button_wiring_numbers: [button_wiring_schematic_number()],
          joltage_requirement: joltage_requirement()
        }

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&parse_machine/1)
  end

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.sum_by(&find_fewest_total_presses/1)
  end

  @impl true
  def part_two(_data, _opts) do
    :not_implemented
  end

  @spec find_fewest_total_presses(machine()) :: integer()
  @spec find_fewest_total_presses(
          [{integer(), integer()}],
          integer(),
          [button_wiring_schematic_number()],
          MapSet.t(integer())
        ) :: integer()
  defp find_fewest_total_presses(%{
         indicator_light_diagram: light,
         button_wiring_numbers: buttons
       }) do
    find_fewest_total_presses([{0, 0}], light, buttons, MapSet.new([]))
  end

  defp find_fewest_total_presses([], _, _, _), do: 0
  defp find_fewest_total_presses([{target, steps} | _], target, _, _), do: steps

  defp find_fewest_total_presses([{arrangement, steps} | rest], target, buttons, visited) do
    new_arrangements =
      buttons
      |> Enum.map(&Math.xor(arrangement, &1))
      |> Enum.reject(&MapSet.member?(visited, &1))

    new_visited = MapSet.union(visited, MapSet.new(new_arrangements))

    to_try = new_arrangements |> Enum.dedup() |> Enum.map(&{&1, steps + 1})
    find_fewest_total_presses(rest ++ to_try, target, buttons, new_visited)
  end

  @spec parse_machine(String.t()) :: machine()
  defp(parse_machine(line)) do
    [indicator_light_diagram_raw | rest] = String.split(line, " ")
    [joltage_requirement_raw | button_wirings_raw] = Enum.reverse(rest)

    joltage_requirement =
      joltage_requirement_raw
      |> get_values_in_brackets()
      |> Enum.map(&String.to_integer/1)

    button_wirings =
      button_wirings_raw
      |> Enum.reduce({[], []}, fn v, {w, n} ->
        values = v |> get_values_in_brackets() |> Enum.map(&String.to_integer/1)
        values_as_number = Enum.reduce(values, 0, &Math.xor(Math.ipow(2, &1), &2))
        {[values | w], [values_as_number | n]}
      end)

    indicator_light_diagram =
      indicator_light_diagram_raw
      |> get_values_in_brackets("")
      |> Enum.with_index()
      |> Enum.reduce(0, fn
        {"#", i}, acc -> Math.xor(Math.ipow(2, i), acc)
        {_, _}, acc -> acc
      end)

    %{
      indicator_light_diagram: indicator_light_diagram,
      button_wirings: elem(button_wirings, 0),
      button_wiring_numbers: elem(button_wirings, 1),
      joltage_requirement: joltage_requirement
    }
  end

  defp get_values_in_brackets(str, splitter \\ ",") do
    str
    |> String.slice(1..-2//1)
    |> String.split(splitter, trim: true)
  end
end

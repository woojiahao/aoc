defmodule Mix.Tasks.Today do
  @moduledoc false

  use Mix.Task

  @start Date.new!(Date.utc_today().year, 12, 1)

  def run([]) do
    part_one()
    part_two()
  end

  def run(["1"]) do
    part_one()
  end

  def run(["2"]) do
    part_two()
  end

  def run(_list) do
    run([])
  end

  defp part_one do
    day = get_day()
    module = get_module(day)
    IO.puts("===== DAY #{day + 1} PART 1 =====")
    apply(String.to_atom(module), :solve_one, []) |> IO.puts()
  end

  defp part_two do
    day = get_day()
    module = get_module(day)
    IO.puts("===== DAY #{day + 1} PART 2 =====")
    apply(String.to_atom(module), :solve_two, []) |> IO.puts()
  end

  defp get_day do
    today = Date.utc_today()
    Date.diff(today, @start)
  end

  defp get_module(day) do
    "Elixir.AOC.TwentyTwentyThree.Day#{day + 1}"
  end
end

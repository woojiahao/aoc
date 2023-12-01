defmodule Mix.Tasks.Today do
  @moduledoc false
  use Mix.Task

  @start Date.new!(Date.utc_today().year, 12, 1)
  @today Date.utc_today()
  @day Date.diff(@today, @start)
  @today_module "Elixir.AOC.TwentyTwentyThree.Day#{@day + 1}"

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
    IO.puts("===== DAY #{@day + 1} PART 1 =====")
    apply(String.to_atom(@today_module), :solve_one, []) |> IO.puts()
  end

  defp part_two do
    IO.puts("===== DAY #{@day + 1} PART 2 =====")
    apply(String.to_atom(@today_module), :solve_two, []) |> IO.puts()
  end
end

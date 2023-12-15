defmodule Mix.Tasks.Day do
  @moduledoc false

  use Mix.Task

  def run([]) do
    Mix.Task.run("today")
  end

  def run([day]) do
    day
    |> String.to_integer()
    |> tap(&part_one(&1))
    |> tap(&part_two(&1))
  end

  def run([day, "1"]) do
    day
    |> String.to_integer()
    |> tap(&part_one(&1))
  end

  def run([day, "2"]) do
    day
    |> String.to_integer()
    |> tap(&part_two(&1))
  end

  def run(_list) do
    run([])
  end

  defp part_one(day) do
    IO.puts("===== DAY #{day} PART 1 =====")
    year = Date.utc_today().year
    module = "Elixir.AOC.Y#{year}.Day#{day}"
    apply(String.to_atom(module), :solve_one, []) |> IO.puts()
  end

  defp part_two(day) do
    IO.puts("===== DAY #{day} PART 2 =====")
    year = Date.utc_today().year
    module = "Elixir.AOC.Y#{year}.Day#{day}"
    apply(String.to_atom(module), :solve_two, []) |> IO.puts()
  end
end

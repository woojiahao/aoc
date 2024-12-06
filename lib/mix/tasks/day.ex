defmodule Mix.Tasks.Day do
  @moduledoc false

  use Mix.Task

  def run([]) do
    raise "Provide at least a year and a day"
  end

  def run([year, day]) do
    {year, day}
    |> tap(&part_one(elem(&1, 0), elem(&1, 1)))
    |> tap(&part_two(elem(&1, 0), elem(&1, 1)))
  end

  def run([year, day, "1"]) do
    {year, day}
    |> tap(&part_one(elem(&1, 0), elem(&1, 1)))
  end

  def run([year, day, "2"]) do
    {year, day}
    |> tap(&part_two(elem(&1, 0), elem(&1, 1)))
  end

  def run(_list) do
    run([])
  end

  defp part_one(year, day) do
    IO.puts("===== YEAR #{year} DAY #{day} PART 1 =====")
    module = "Elixir.AOC.Y#{year}.Day#{day}"
    before = :os.system_time(:millisecond)
    result = apply(String.to_atom(module), :solve_one, [])
    now = :os.system_time(:millisecond)
    IO.puts("Result: #{result}")
    IO.puts("Took: #{now - before}ms")
  end

  defp part_two(year, day) do
    IO.puts("===== YEAR #{year} DAY #{day} PART 2 =====")
    module = "Elixir.AOC.Y#{year}.Day#{day}"
    before = :os.system_time(:millisecond)
    result = apply(String.to_atom(module), :solve_two, [])
    now = :os.system_time(:millisecond)
    IO.puts("Result: #{result}")
    IO.puts("Took: #{now - before}ms")
  end
end

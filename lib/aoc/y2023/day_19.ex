defmodule AOC.Y2023.Day19 do
  @moduledoc """
  Part 1 is a simple traversal per rating to figure out the outcome.

  Part 2 likely requires starting from the back and going from all accepted states and reversing
  to see what led to this state
  """
  use AOC.Solution

  @workflow_pattern ~r/(\w+)\{(.+)\}/
  @categories ~w(x m a s)

  @impl true
  def load_data() do
    [workflows, ratings] =
      Data.load_day(19, "\n\n")
      |> Enum.map(&String.split(&1, "\n", trim: true))

    parsed_workflows = Map.new(workflows, &parse_workflow/1)

    parsed_ratings =
      Enum.map(ratings, fn rating ->
        rating
        |> String.slice(1..-2)
        |> String.split(",", trim: true)
        |> Enum.map(&String.split(&1, "=", trim: true))
        |> Enum.map(fn [_, v] -> String.to_integer(v) end)
        |> Enum.zip(@categories)
        |> Map.new(fn {v, c} -> {c, v} end)
      end)

    {parsed_workflows, parsed_ratings}
  end

  defp parse_workflow(workflow) do
    [_, name, instructions] = Regex.run(@workflow_pattern, workflow)

    steps =
      instructions
      |> String.split(",", trim: true)
      |> Enum.map(fn instruction ->
        if String.contains?(instruction, ":") do
          # Set up a conditional invocation
          [condition, o] = String.split(instruction, ":")
          [c, v] = String.split(condition, ~r/<|>/)
          cmp = if String.contains?(condition, ">"), do: :gt, else: :lt
          {:conditional, c, String.to_integer(v), cmp, o}
        else
          {:jump, instruction}
        end
      end)

    {name, steps}
  end

  @impl true
  def part_one({workflows, ratings}) do
    ratings
    |> Enum.map(&{&1, process(workflows["in"], &1, workflows)})
    |> Enum.filter(&(elem(&1, 1) == :A))
    |> General.map_sum(fn {%{"x" => x, "m" => m, "a" => a, "s" => s}, _} -> x + m + a + s end)
  end

  @impl true
  def part_two({workflows, _}) do
    chunk_size = 10

    |> Task.async_stream(
      fn i ->
        from = i * chunk_size + 1
        to = (i + 1) * chunk_size

        for x <- from..to,
            m <- from..to,
            a <- from..to,
            s <- from..to do
          process(workflows["in"], %{"x" => x, "m" => m, "a" => a, "s" => s}, workflows)
        end
        |> IO.inspect()
        |> Enum.count(&(&1 == :A))
      end,
      max_concurrency: System.schedulers_online() * 2,
      ordered: false,
      timeout: :infinity
    )
    |> Enum.reduce(0, fn {_, v}, acc -> acc + v end)
  end

  defp process([{:jump, "A"} | _], _, _), do: :A
  defp process([{:jump, "R"} | _], _, _), do: :R

  defp process([{:jump, next} | _], rating, workflows),
    do: process(workflows[next], rating, workflows)

  defp process([{:conditional, c, v, cmp, o} | rest], rating, workflows) do
    if (cmp == :lt and rating[c] < v) or
         (cmp == :gt and rating[c] > v) do
      process([{:jump, o}], rating, workflows)
    else
      process(rest, rating, workflows)
    end
  end
end

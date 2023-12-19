defmodule AOC.Y2023.Day19 do
  @moduledoc """
  Part 1 is a simple traversal per rating to figure out the outcome.

  Part 2 likely requires starting from the back and going from all accepted states and reversing
  to see what led to this state. This lets us track what ranges of x,m,a,s can reach that given
  A state and we can just use those values
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

  @impl true
  def part_two({workflows, _}) do
    {:ok, agent} = Agent.start_link(fn -> [] end)

    tree(workflows["in"], workflows, [], agent)

    Agent.get(agent, fn content ->
      content
      |> General.map_sum(fn steps ->
        # For each step, we need to constraint x, m, a, s to fit within the path
        initial =
          @categories
          |> Map.new(&{&1, 1..4000})

        Enum.reduce(steps, initial, fn
          {c, :lt, v}, acc -> Map.update!(acc, c, fn l.._ -> l..(v - 1) end)
          {c, :gt, v}, acc -> Map.update!(acc, c, fn _..u -> (v + 1)..u end)
          {c, :lte, v}, acc -> Map.update!(acc, c, fn l.._ -> l..v end)
          {c, :gte, v}, acc -> Map.update!(acc, c, fn _..u -> v..u end)
        end)
        |> Enum.reduce(1, fn {_, l..u}, acc -> acc * (u - l + 1) end)
      end)
    end)
  end

  defp tree([{:jump, "A"} | _], _, path, agent), do: Agent.update(agent, &(&1 ++ [path]))
  defp tree([{:jump, "R"} | _], _, _, _), do: nil

  defp tree([{:jump, next} | _], workflows, path, agent),
    do: tree(workflows[next], workflows, path, agent)

  defp tree([{:conditional, c, v, cmp, o} | rest], workflows, path, agent) do
    if o == "A" do
      # If this path can reach "A", then add to global store
      Agent.update(agent, &(&1 ++ [path ++ [{c, cmp, v}]]))
    end

    if o != "R" and o != "A" do
      # If the outcome leads to another workflow, follow it
      tree(workflows[o], workflows, path ++ [{c, cmp, v}], agent)
    end

    # Regardless of outcome, we need to follow the inverse path
    tree(rest, workflows, path ++ [{c, inverse_cmp(cmp), v}], agent)
  end

  defp inverse_cmp(:lt), do: :gte
  defp inverse_cmp(:gt), do: :lte
end

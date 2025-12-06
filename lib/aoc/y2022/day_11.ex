defmodule AOC.Y2022.Day11 do
  @moduledoc false

  use AOC.Solution, year: 2022, day: 11
  import Utils.General, [:map_product]
  import Utils.Math, [:lcm]

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(fn
      [
        _,
        "  Starting items: " <> starting_items,
        "  Operation: new = old " <> operation,
        "  Test: divisible by " <> test,
        "    If true: throw to monkey " <> true_monkey,
        "    If false: throw to monkey " <> false_monkey
      ] ->
        items = starting_items |> String.split(", ") |> Enum.map(&String.to_integer/1)
        operation_fn = parse_operation(operation)

        monkey = %{
          operation: operation_fn,
          divisibility: String.to_integer(test),
          true_monkey: String.to_integer(true_monkey),
          false_monkey: String.to_integer(false_monkey)
        }

        {monkey, items}
    end)
    |> Enum.with_index()
    |> then(fn entries ->
      monkey_items = Map.new(entries, fn {{_monkey, items}, idx} -> {idx, items} end)
      monkey_data = Map.new(entries, fn {{monkey, _items}, idx} -> {idx, monkey} end)
      {monkey_data, monkey_items, length(entries)}
    end)
  end

  defp parse_operation("* old"), do: fn old -> old * old end
  defp parse_operation("+ old"), do: fn old -> old + old end
  defp parse_operation("* " <> v), do: fn old -> old * String.to_integer(v) end
  defp parse_operation("+ " <> v), do: fn old -> old + String.to_integer(v) end

  @impl true
  def part_one({monkey_data, monkey_items, monkey_count}, _opts) do
    inspection_count = Map.new(0..(monkey_count - 1), fn i -> {i, 0} end)

    1..20
    |> Enum.reduce(
      {monkey_items, inspection_count},
      fn _count, {acc_monkey_items, acc_inspection_count} ->
        monkey_round(monkey_data, acc_monkey_items, monkey_count, acc_inspection_count)
      end
    )
    |> elem(1)
    |> Enum.sort_by(fn {_monkey, count} -> count end)
    |> Enum.take(-2)
    |> map_product(fn {_monkey, count} -> count end)
  end

  @impl true
  def part_two({monkey_data, monkey_items, monkey_count}, _opts) do
    inspection_count = Map.new(0..(monkey_count - 1), fn i -> {i, 0} end)

    1..10_000
    |> Enum.reduce(
      {monkey_items, inspection_count},
      fn _count, {acc_monkey_items, acc_inspection_count} ->
        monkey_round(monkey_data, acc_monkey_items, monkey_count, acc_inspection_count, false)
      end
    )
    |> elem(1)
    |> Enum.sort_by(fn {_monkey, count} -> count end)
    |> Enum.take(-2)
    |> map_product(fn {_monkey, count} -> count end)
  end

  defp monkey_round(monkey_data, monkey_items, monkey_count, inspection_count, has_ease? \\ true) do
    0..(monkey_count - 1)
    |> Enum.reduce({monkey_items, inspection_count}, fn monkey,
                                                        {acc_monkey_items, acc_inspection_count} ->
      updated_inspection_count =
        Map.update!(acc_inspection_count, monkey, fn prev ->
          prev + length(acc_monkey_items[monkey])
        end)

      updated_monkey_items =
        monkey_items_evaluate(monkey_data, monkey, acc_monkey_items[monkey], has_ease?)
        |> Enum.reduce(acc_monkey_items, fn {target_monkey, items}, inner_acc ->
          cur_items = Map.get(inner_acc, target_monkey, [])
          updated_items = cur_items ++ items
          Map.put(inner_acc, target_monkey, updated_items)
        end)
        |> Map.put(monkey, [])

      {updated_monkey_items, updated_inspection_count}
    end)
  end

  defp monkey_items_evaluate(monkey_data, monkey, items, has_ease?) do
    items
    |> Enum.map(fn item ->
      divisibility_lcm =
        monkey_data
        |> Enum.map(fn {_monkey, %{divisibility: divisibility}} -> divisibility end)
        |> lcm()

      new_worry =
        if has_ease?,
          do: div(monkey_data[monkey].operation.(item), 3),
          else: rem(monkey_data[monkey].operation.(item), divisibility_lcm)

      truth_test = rem(new_worry, monkey_data[monkey].divisibility) == 0

      {new_worry,
       if(truth_test, do: monkey_data[monkey].true_monkey, else: monkey_data[monkey].false_monkey)}
    end)
    |> Enum.group_by(fn {_worry, monkey} -> monkey end, fn {worry, _monkey} -> worry end)
  end
end

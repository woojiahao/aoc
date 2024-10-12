defmodule AOC.Y2023.Day20 do
  @moduledoc """
  Part 1 is tracing the movement using level-wise BFS.

  Part 2 is noticing that &bb -> rx
  For rx to receive low pulse, &bb needs to send low pulse
  &ct, &kp, &ks, &xc -> &bb so each has to send a high pulse
  Find the LCM across all the times for each to send a high pulse to solve
  """
  use AOC.Solution

  @delimiter " -> "
  @type pulse_type :: {binary(), binary(), number()}
  @final "rx"
  @press_signal {"button", "broadcaster", 0}

  @impl true
  def load_data() do
    Data.load_day(2023, 20)
    |> Enum.map(fn
      "%" <> rest -> {:ff, rest}
      "&" <> rest -> {:co, rest}
      rest -> {:br, rest}
    end)
    |> Enum.map(fn {type, str} ->
      [name, outputs_str] = String.split(str, @delimiter, trim: true)
      {type, {name, String.split(outputs_str, ", ", trim: true)}}
    end)
    |> Map.new(fn {type, {name, outputs}} -> {name, {type, outputs}} end)
    |> then(fn modules ->
      Map.new(modules, fn {name, {type, outputs}} ->
        body =
          %{type: type, outputs: outputs}
          |> General.merge_if(type == :ff, %{state: 0})
          |> General.merge_if(type == :co, %{
            inputs: find_conjunction_inputs(name, modules)
          })

        {name, body}
      end)
      |> Map.merge(%{"button" => %{type: :bu, outputs: ["broadcaster"]}})
    end)
  end

  defp find_conjunction_inputs(conjunction, modules) do
    modules
    |> Enum.filter(fn {_, {_, outputs}} -> Enum.any?(outputs, &(&1 == conjunction)) end)
    |> Map.new(fn {name, {_, _}} -> {name, 0} end)
  end

  @impl true
  def part_one(data) do
    1..1000
    |> Enum.reduce(
      {data, 0, 0},
      fn _, {acc, lows, highs} -> press([@press_signal], acc, lows + 1, highs) end
    )
    |> then(fn {_, l, h} -> l * h end)
  end

  defp press([], modules, lows, highs), do: {modules, lows, highs}

  defp press(signals, modules, lows, highs) do
    signals
    |> Enum.reduce({modules, []}, fn a, b -> recv(a, b) end)
    |> then(fn {modules, signals} ->
      count = fn v -> Enum.count(signals, &(elem(&1, 2) == v)) end
      press(signals, modules, lows + count.(0), highs + count.(1))
    end)
  end

  @impl true
  def part_two(data) do
    find_parent_modules = fn parent ->
      data
      |> Enum.filter(fn {_, %{outputs: outputs}} ->
        Enum.find(outputs, &(&1 == parent)) != nil
      end)
      |> Enum.map(&elem(&1, 0))
    end

    parent = find_parent_modules.(@final) |> List.first()
    grandparents = find_parent_modules.(parent)

    1..5000
    |> Stream.transform({data, grandparents, []}, fn
      _, {_, _, found} = acc when length(found) == length(grandparents) ->
        {:halt, acc}

      i, {modules, to_find, found} ->
        {p_modules, p_found} = tracked_press([@press_signal], modules, to_find, [])
        u_found = found ++ Enum.map(p_found, &{&1, i})

        {
          [u_found],
          {p_modules, Set.list_difference(to_find, p_found), u_found}
        }
    end)
    |> Enum.to_list()
    |> List.last()
    |> General.map_product(&elem(&1, 1))
  end

  defp tracked_press([], modules, _, found), do: {modules, found}

  defp tracked_press(signals, modules, to_find, found) do
    signals
    |> Enum.reduce({modules, []}, fn a, b -> recv(a, b) end)
    |> then(fn {modules, signals} ->
      # If the senders include the grandparents to track and they send a high pulse
      high_pulse_senders = signals |> Enum.filter(&(elem(&1, 2) == 1)) |> Enum.map(&elem(&1, 0))
      found_senders = Set.list_intersection(to_find, high_pulse_senders)
      tracked_press(signals, modules, to_find, found ++ found_senders)
    end)
  end

  defp recv({_, receiver, _} = signal, {modules, signals}) when is_map_key(modules, receiver) do
    module = modules[receiver]
    updated_modules = update_modules(modules, module, signal)
    {updated_modules, signals ++ next_signals(updated_modules, module, signal)}
  end

  defp recv(_, v), do: v

  defp update_modules(modules, %{type: :ff}, {_, receiver, 0}),
    do: update_in(modules[receiver][:state], &(1 - &1))

  defp update_modules(modules, %{type: :co}, {sender, receiver, pulse}),
    do: update_in(modules[receiver][:inputs][sender], fn _ -> pulse end)

  defp update_modules(modules, _, _), do: modules

  defp next_signals(modules, %{type: :ff, outputs: outputs}, {_, receiver, 0}),
    do: Enum.map(outputs, &{receiver, &1, modules[receiver][:state]})

  defp next_signals(modules, %{type: :co, outputs: outputs}, {_, receiver, _}),
    do:
      Enum.map(
        outputs,
        &{receiver, &1,
         if(Enum.all?(modules[receiver][:inputs], fn {_, v} -> v == 1 end), do: 0, else: 1)}
      )

  defp next_signals(_, %{type: :br, outputs: outputs}, {_, _, _}),
    do: Enum.map(outputs, &{"broadcaster", &1, 0})

  defp next_signals(_, _, _), do: []
end

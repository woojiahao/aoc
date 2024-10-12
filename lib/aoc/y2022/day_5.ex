defmodule AOC.Y2022.Day5 do
  @moduledoc false

  use AOC.Solution
  import Utils.String, [:chunk_every]
  import Utils.Array, [:transpose]

  @move_regexp ~r/^move (\d+) from (\d+) to (\d+)$/

  @impl true
  def load_data() do
    Data.load_day(2022, 5, "\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> then(fn [crates, moves] ->
      {crates |> Enum.drop(-1) |> parse_crates(), parse_moves(moves)}
    end)
  end

  @impl true
  def part_one(data) do
    {crate_count, updated_crates} =
      data
      |> then(fn {{crate_count, crates}, moves} ->
        {crate_count,
         moves
         |> Enum.reduce(crates, fn {count, from, to}, cur_crates ->
           cur_crates
           |> Map.put(from, Enum.drop(cur_crates[from], count))
           |> Map.put(
             to,
             (Enum.take(cur_crates[from], count) |> Enum.reverse()) ++ cur_crates[to]
           )
         end)}
      end)

    1..crate_count |> Enum.map(&updated_crates[&1]) |> Enum.map_join(&List.first/1)
  end

  @impl true
  def part_two(data) do
    {crate_count, updated_crates} =
      data
      |> then(fn {{crate_count, crates}, moves} ->
        {crate_count,
         moves
         |> Enum.reduce(crates, fn {count, from, to}, cur_crates ->
           cur_crates
           |> Map.put(from, Enum.drop(cur_crates[from], count))
           |> Map.put(
             to,
             Enum.take(cur_crates[from], count) ++ cur_crates[to]
           )
         end)}
      end)

    1..crate_count |> Enum.map(&updated_crates[&1]) |> Enum.map_join(&List.first/1)
  end

  defp parse_crates(crates) do
    max_row_length = crates |> Enum.map(&String.length/1) |> Enum.max()

    crate_map =
      crates
      |> Enum.map(&String.pad_trailing(&1, max_row_length))
      |> Enum.map(&chunk_every(&1, 4))
      |> Enum.map(fn row -> Enum.map(row, &String.trim/1) end)
      |> Enum.map(fn
        row ->
          Enum.map(row, fn
            "" -> ""
            v -> String.at(v, 1)
          end)
      end)
      |> transpose()
      |> Enum.map(fn row -> Enum.filter(row, &(&1 != "")) end)
      |> Enum.with_index(1)
      |> Map.new(fn {row, idx} -> {idx, row} end)

    {div(max_row_length + 1, 4), crate_map}
  end

  defp parse_moves([]), do: []

  defp parse_moves([move | rest]) do
    [count, from, to] =
      @move_regexp |> Regex.run(move, capture: :all_but_first) |> Enum.map(&String.to_integer/1)

    [{count, from, to}] ++ parse_moves(rest)
  end
end

defmodule AOC.Y2023.Day3 do
  @moduledoc false

  use AOC.Solution, year: 2023, day: 3

  @numbers Enum.map(0..9, &Integer.to_string/1)
  @neighbors [[0, 1], [0, -1], [1, 0], [-1, 0], [-1, 1], [1, 1], [1, -1], [-1, -1]]

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", trim: true))
    |> then(fn raw_data ->
      raw_data
      |> Enum.with_index()
      |> Enum.map(&parse_row(Enum.with_index(elem(&1, 0)), elem(&1, 1), raw_data, []))
    end)
  end

  defp parse_row([], _row_idx, _matrix, acc), do: acc

  defp parse_row([{ch, idx} | _rest] = row, row_idx, matrix, acc) when ch in @numbers do
    {l, num} = parse_number(row, 0, 0)

    remaining = Enum.slice(row, l..(length(row) - 1))
    neighbors = is_part_number?(row_idx, idx, idx, idx + l - 1, matrix)

    if map_size(neighbors) > 0 do
      parse_row(remaining, row_idx, matrix, acc ++ [{num, neighbors}])
    else
      parse_row(remaining, row_idx, matrix, acc)
    end
  end

  defp parse_row([{_ch, _idx} | rest], row_idx, matrix, acc),
    do: parse_row(rest, row_idx, matrix, acc)

  defp is_part_number?(_row, col, _start_col, end_col, _matrix) when col > end_col, do: %{}

  defp is_part_number?(row, col, start_col, end_col, matrix) do
    is_remaining_part_number = is_part_number?(row, col + 1, start_col, end_col, matrix)

    m = length(matrix)
    n = matrix |> Enum.at(0) |> length()

    Enum.reduce(@neighbors, is_remaining_part_number, fn [dr, dc], status ->
      cur_status =
        with nr <- row + dr,
             nc <- col + dc,
             false <- nr < 0 or nc < 0 or nr >= m or nc >= n,
             v <- matrix |> Enum.at(nr) |> Enum.at(nc),
             true <- v not in @numbers and v != "." do
          %{{nr, nc} => v}
        else
          _ -> %{}
        end

      Map.merge(status, cur_status)
    end)
  end

  defp parse_number([{ch, _idx} | rest], l, acc) when ch in @numbers,
    do: parse_number(rest, l + 1, acc * 10 + String.to_integer(ch))

  defp parse_number(_row, l, acc), do: {l, acc}

  @impl true
  def part_one(data, _opts) do
    data
    |> Enum.map(fn row -> Enum.map(row, &elem(&1, 0)) end)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sum()
  end

  @impl true
  def part_two(data, _opts) do
    data
    |> Enum.filter(&(length(&1) > 0))
    |> Enum.map(fn row ->
      row
      |> Enum.filter(fn {_num, neighbors} ->
        Enum.any?(neighbors, &(elem(&1, 1) == "*"))
      end)
    end)
    |> Enum.filter(&(length(&1) > 0))
    |> Enum.flat_map(& &1)
    |> Enum.group_by(fn {_num, neighbors} -> Map.keys(neighbors) end, fn {num, _} -> num end)
    |> Enum.filter(fn {_key, value} -> length(value) == 2 end)
    |> Enum.map(fn {_key, [first, second]} -> first * second end)
    |> Enum.sum()
  end
end

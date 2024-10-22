defmodule AOC.Y2021.Day4 do
  @moduledoc false

  use AOC.Solution
  import Utils.Array, [:from_matrix_to_coord_map]
  import Utils.General, [:map_sum, :parse_space_delimited_matrix]

  @board_width 5
  @board_height 5

  @impl true
  def load_data() do
    Data.load_day(2021, 4, "\n\n")
    |> then(fn [calls | boards] ->
      call_numbers = calls |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)

      boards_parsed =
        boards
        |> Enum.map(fn board ->
          board
          |> parse_space_delimited_matrix()
          |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
          |> from_matrix_to_coord_map()
        end)

      {call_numbers, boards_parsed}
    end)
  end

  @impl true
  def part_one({calls, boards}) do
    calls
    |> Enum.reduce_while(MapSet.new(), fn call, called ->
      updated_called = MapSet.put(called, call)
      bingo_status = Enum.map(boards, &has_bingo?(&1, updated_called))
      bingo_found? = Enum.find_index(bingo_status, &(&1 == true))

      if is_nil(bingo_found?) do
        {:cont, updated_called}
      else
        sum_all =
          boards
          |> Enum.at(bingo_found?)
          |> map_sum(fn {_, v} ->
            if MapSet.member?(updated_called, v), do: 0, else: v
          end)

        {:halt, sum_all * call}
      end
    end)
  end

  @impl true
  def part_two({calls, boards}) do
    {last_board_idx, last_board_called} =
      calls
      |> Enum.reduce({MapSet.new(), [], []}, fn call, {called_set, called_lst, bingos} ->
        updated_called_set = MapSet.put(called_set, call)
        updated_called_lst = called_lst ++ [call]

        new_bingos =
          boards
          |> Enum.with_index()
          |> Enum.reject(fn {_, idx} ->
            Enum.any?(bingos, fn {bingo_idx, _} -> idx == bingo_idx end)
          end)
          |> Enum.filter(fn {board, _} -> has_bingo?(board, updated_called_set) end)
          |> Enum.map(fn {_, idx} -> {idx, updated_called_lst} end)

        {updated_called_set, updated_called_lst, bingos ++ new_bingos}
      end)
      |> elem(2)
      |> List.last()

    last_board_unmarked_sum =
      boards
      |> Enum.at(last_board_idx)
      |> map_sum(fn {_, v} ->
        if Enum.any?(last_board_called, &(&1 == v)), do: 0, else: v
      end)

    last_called_number = List.last(last_board_called)

    last_board_unmarked_sum * last_called_number
  end

  defp has_bingo?(board, called) do
    row_bingo =
      0..(@board_height - 1)
      |> Enum.any?(fn i ->
        Enum.all?(0..(@board_width - 1), fn j ->
          MapSet.member?(called, board[{i, j}])
        end)
      end)

    col_bingo =
      0..(@board_width - 1)
      |> Enum.any?(fn j ->
        Enum.all?(0..(@board_height - 1), fn i ->
          MapSet.member?(called, board[{i, j}])
        end)
      end)

    row_bingo or col_bingo
  end
end

defmodule AOC.Y2022.Day2 do
  @moduledoc false

  use AOC.Solution
  import Utils.String, [:ord]

  @impl true
  def load_data() do
    Data.load_day(2022, 2)
    |> Enum.map(fn game ->
      [opponent, player] = String.split(game, " ")
      player_score = ord(player) - ord("X") + 1
      opponent_score = ord(opponent) - ord("A") + 1
      {player_score, opponent_score}
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn {player, opponent} -> player + play(player, opponent) end)
    |> Enum.sum()
  end

  @impl true
  def part_two(data) do
    data
    |> Enum.map(fn {outcome, opponent} -> sly(outcome, opponent) + (outcome - 1) * 3 end)
    |> Enum.sum()
  end

  defp play(1, 1), do: 3
  defp play(1, 2), do: 0
  defp play(1, 3), do: 6

  defp play(2, 1), do: 6
  defp play(2, 2), do: 3
  defp play(2, 3), do: 0

  defp play(3, 1), do: 0
  defp play(3, 2), do: 6
  defp play(3, 3), do: 3

  defp sly(1, 1), do: 3
  defp sly(1, 2), do: 1
  defp sly(1, 3), do: 2

  defp sly(2, 1), do: 1
  defp sly(2, 2), do: 2
  defp sly(2, 3), do: 3

  defp sly(3, 1), do: 2
  defp sly(3, 2), do: 3
  defp sly(3, 3), do: 1
end

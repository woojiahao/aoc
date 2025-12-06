defmodule AOC.Y2021.Day3 do
  @moduledoc false

  use AOC.Solution, year: 2021, day: 3
  import Utils.Array, [:transpose]
  import Utils.General, [:map_max]

  @impl true
  def load_data(data, _opts) do
    data
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  @impl true
  def part_one(data, _opts) do
    bit_frequencies = get_bit_frequencies(data)

    {gamma, _} =
      bit_frequencies
      |> Enum.map_join(fn %{"0" => zeroes, "1" => ones} ->
        if zeroes > ones, do: "0", else: "1"
      end)
      |> Integer.parse(2)

    {epsilon, _} =
      bit_frequencies
      |> Enum.map_join(fn %{"0" => zeroes, "1" => ones} ->
        if zeroes > ones, do: "1", else: "0"
      end)
      |> Integer.parse(2)

    gamma * epsilon
  end

  @impl true
  def part_two(data, _opts) do
    max_length = map_max(data, &length/1)

    oxygen_str =
      Enum.reduce_while(0..(max_length - 1), data, fn
        _, acc when length(acc) == 1 ->
          {:halt, Enum.at(acc, 0)}

        idx, acc ->
          bit_frequencies = get_bit_frequencies(acc)
          %{"0" => zeroes, "1" => ones} = Enum.at(bit_frequencies, idx)
          most_freq = if zeroes > ones, do: "0", else: "1"
          {:cont, Enum.filter(acc, fn row -> Enum.at(row, idx) == most_freq end)}
      end)
      |> Enum.join()

    carbon_dioxide_str =
      Enum.reduce_while(0..(max_length - 1), data, fn
        _, acc when length(acc) == 1 ->
          {:halt, Enum.at(acc, 0)}

        idx, acc ->
          bit_frequencies = get_bit_frequencies(acc)
          %{"0" => zeroes, "1" => ones} = Enum.at(bit_frequencies, idx)
          least_freq = if zeroes <= ones, do: "0", else: "1"
          {:cont, Enum.filter(acc, fn row -> Enum.at(row, idx) == least_freq end)}
      end)
      |> Enum.join()

    {oxygen, _} = Integer.parse(oxygen_str, 2)
    {carbon_dioxide, _} = Integer.parse(carbon_dioxide_str, 2)

    oxygen * carbon_dioxide
  end

  defp get_bit_frequencies(data) do
    data
    |> transpose()
    |> Enum.map(&Enum.frequencies/1)
  end
end

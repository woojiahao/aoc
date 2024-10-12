defmodule AOC.Y2022.Day7 do
  @moduledoc false

  use AOC.Solution
  import Utils.General, [:map_sum]

  @impl true
  def load_data() do
    Data.load_day(2022, 7)
    |> Enum.reduce({%{}, []}, fn
      "$ cd ..", {acc, cur_dir} ->
        {acc, Enum.drop(cur_dir, -1)}

      "$ cd " <> cd, {acc, cur_dir} ->
        {acc, cur_dir ++ [cd]}

      "$ ls", acc ->
        acc

      "dir " <> dir, {acc, cur_dir} ->
        {acc
         |> Map.put_new(cur_dir ++ [dir], [])
         |> Map.put(cur_dir, Map.get(acc, cur_dir, []) ++ [{:folder, dir}]), cur_dir}

      file, {acc, cur_dir} ->
        [size, name] = String.split(file)

        {Map.put(
           acc,
           cur_dir,
           Map.get(acc, cur_dir, []) ++ [{:file, name, String.to_integer(size)}]
         ), cur_dir}
    end)
    |> elem(0)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.map(fn {folder, _files} -> folder_size(folder, data) end)
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  @impl true
  def part_two(data) do
    root_size = folder_size(["/"], data)

    data
    |> Enum.map(fn {folder, _files} -> folder_size(folder, data) end)
    |> Enum.filter(&(&1 >= root_size - 40_000_000))
    |> Enum.min()
  end

  defp folder_size(cur, folder) when not is_map_key(folder, cur), do: 0

  defp folder_size(cur, folder) do
    map_sum(folder[cur], fn
      {:folder, folder_name} -> folder_size(cur ++ [folder_name], folder)
      {:file, _file_name, file_size} -> file_size
    end)
  end
end

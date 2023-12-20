defmodule Utils.Set do
  @moduledoc """
  Provides utility for common MapSet operations like finding the intersection between two
  lists.
  """

  def list_intersection(list1, list2) do
    list1 |> MapSet.new() |> MapSet.intersection(MapSet.new(list2)) |> Enum.to_list()
  end

  def list_difference(list1, list2) do
    list1 |> MapSet.new() |> MapSet.difference(MapSet.new(list2)) |> Enum.to_list()
  end
end

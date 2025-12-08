defmodule Utils.UFDS do
  @moduledoc false

  defstruct [:n, :parents, :ranks, :unions]

  def new(n) do
    %__MODULE__{
      n: n,
      parents: Map.new(0..(n - 1), fn k -> {k, k} end),
      ranks: Map.new(0..(n - 1), fn k -> {k, 1} end),
      unions: n
    }
  end

  def find(ufds, p) do
    parent = ufds.parents[p]

    if parent == p do
      {ufds, p}
    else
      {ufds, root} = find(ufds, parent)
      ufds = %__MODULE__{ufds | parents: Map.put(ufds.parents, p, root)}
      {ufds, root}
    end
  end

  def union(ufds, p, q) do
    {ufds, root_p} = find(ufds, p)
    {ufds, root_q} = find(ufds, q)

    if root_p == root_q do
      ufds
    else
      size_p = ufds.ranks[root_p]
      size_q = ufds.ranks[root_q]

      {parents, ranks} =
        if size_p > size_q do
          parents = Map.put(ufds.parents, root_q, root_p)
          ranks = Map.put(ufds.ranks, root_p, size_p + size_q)
          {parents, ranks}
        else
          parents = Map.put(ufds.parents, root_p, root_q)
          ranks = Map.put(ufds.ranks, root_q, size_p + size_q)
          {parents, ranks}
        end

      %__MODULE__{ufds | parents: parents, ranks: ranks, unions: ufds.unions - 1}
    end
  end

  def union_sizes(%__MODULE__{parents: parents} = ufds) do
    Enum.reduce(parents, %{}, fn {k, _}, acc ->
      {_, root} = find(ufds, k)
      Map.update(acc, root, 1, &(&1 + 1))
    end)
  end
end

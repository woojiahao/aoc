defmodule Utils.Heap do
  @moduledoc false

  defstruct [:data, :size, :max_size, :cmp]

  @type t :: %__MODULE__{
          data: :array.array(any()),
          size: non_neg_integer(),
          max_size: non_neg_integer() | :infinity,
          cmp: (any(), any() -> boolean())
        }

  def new(cmp, max_size \\ :infinity) when is_function(cmp, 2) do
    %__MODULE__{data: :array.new(), size: 0, max_size: max_size, cmp: cmp}
  end

  def from_list(list, cmp, max_size \\ :infinity) do
    arr = :array.from_list(list)
    size = length(list)
    heap = %__MODULE__{data: arr, size: size, max_size: max_size, cmp: cmp}

    last_parent = div(size - 2, 2)

    Enum.reduce(last_parent..0//-1, heap, fn i, h ->
      sift_down(h, i)
    end)
  end

  def peek(%__MODULE__{size: 0}), do: nil
  def peek(%__MODULE__{data: data}), do: :array.get(0, data)

  def insert(%__MODULE__{data: data, size: size, cmp: cmp, max_size: max} = heap, element) do
    data = :array.set(size, element, data)
    heap = %__MODULE__{heap | data: data, size: size + 1}
    heap = sift_up(heap, size)

    if max != :infinity and heap.size > max do
      {heap, _} = pop(heap)
      heap
    else
      heap
    end
  end

  def pop(%__MODULE__{size: 0} = heap), do: {heap, nil}

  def pop(%__MODULE__{data: data, size: size} = heap) do
    top = :array.get(0, data)
    last = :array.get(size - 1, data)
    data = :array.set(0, last, data)
    heap = %__MODULE__{heap | data: data, size: size - 1}
    heap = sift_down(heap, 0)
    {heap, top}
  end

  defp swap(data, i, j) do
    xi = :array.get(i, data)
    xj = :array.get(j, data)

    data = :array.set(i, xj, data)
    :array.set(j, xi, data)
  end

  defp sift_up(heap, 0), do: heap

  defp sift_up(%__MODULE__{data: data, cmp: cmp} = heap, i) do
    parent = div(i - 1, 2)

    if cmp.(:array.get(i, data), :array.get(parent, data)) do
      data = swap(data, i, parent)
      sift_up(%{heap | data: data}, parent)
    else
      heap
    end
  end

  defp sift_down(%__MODULE__{data: data, size: size, cmp: cmp} = heap, i) do
    left = 2 * i + 1
    right = 2 * i + 2
    selected = i

    selected =
      if left < size and cmp.(:array.get(left, data), :array.get(selected, data)),
        do: left,
        else: selected

    selected =
      if right < size and cmp.(:array.get(right, data), :array.get(selected, data)),
        do: right,
        else: selected

    if selected != i do
      data = swap(data, i, selected)
      sift_down(%{heap | data: data}, selected)
    else
      heap
    end
  end
end

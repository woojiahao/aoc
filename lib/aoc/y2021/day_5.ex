defmodule AOC.Y2021.Day5 do
  @moduledoc false

  use AOC.Solution

  @impl true
  def load_data() do
    Data.load_day(2021, 5)
    |> Enum.map(fn line -> String.split(line, " -> ") end)
    |> Enum.map(fn [from, to] -> {String.split(from, ","), String.split(to, ",")} end)
    |> Enum.map(fn {[a, b], [c, d]} ->
      {{String.to_integer(a), String.to_integer(b)}, {String.to_integer(c), String.to_integer(d)}}
    end)
    |> Enum.map(fn
      {{a, b}, {a, d}} ->
        {:vert, a, min(b, d)..max(b, d)}

      {{a, b}, {c, b}} ->
        {:hort, min(a, c)..max(a, c), b}

      {{a, b}, {c, d}} when d - b == a - c ->
        {:diag, {a, b}, {c, d} -1, b - a}

      {{a, b}, {c, d}} ->
        {:diag, {a, b}, {c, d}, 1, b - a}
    end)
    |> tap(fn data ->
      data |> Enum.filter(fn v -> elem(v, 0) == :diag end) |> IO.inspect()
    end)
  end

  @impl true
  def part_one(data) do
    data
    |> Enum.reject(fn v -> elem(v, 0) == :diag end)
    |> then(fn filtered ->
      l = length(filtered)

      for i <- 0..(l - 1)//1 do
        for j <- (i + 1)..(l - 1)//1 do
          intersections(Enum.at(filtered, i), Enum.at(filtered, j))
        end
        |> Enum.flat_map(& &1)
      end
      |> Enum.flat_map(& &1)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  @impl true
  def part_two(data) do
    data
    |> then(fn filtered ->
      l = length(filtered)

      for i <- 0..(l - 1)//1 do
        for j <- (i + 1)..(l - 1)//1 do
          intersections(Enum.at(filtered, i), Enum.at(filtered, j))
        end
        |> Enum.flat_map(& &1)
      end
      |> Enum.flat_map(& &1)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp intersections({:vert, sx, sy1..sy2//_}, {:vert, sx, ty1..ty2//_})
       when sy1 < ty2 and ty1 < sy2,
       do: for(y <- max(sy1, ty1)..min(sy2, ty2), do: {sx, y})

  defp intersections({:hort, sx1..sx2//_, sy}, {:hort, tx1..tx2//_, sy})
       when sx1 < tx2 and tx1 < sx2,
       do: for(x <- max(sx1, tx1)..min(sx2, tx2), do: {x, sy})

  defp intersections(
         {:diag, {sa, sb}, {sc, sd}, g, b},
         {:diag, {ta, tb}, {tc, td}, g, b}
       )
       when sx1 < tx2 and tx1 < sx2 and sy1 < ty2 and ty1 < sy2 do
    g |> IO.inspect()
    x_range = max(sx1, tx1)..min(sx2, tx2) |> IO.inspect()
    y_range = max(sy1, ty1)..min(sy2, ty2) |> IO.inspect()

    {max(sx1, tx1), max(sy1, ty1)}
    |> Stream.iterate(fn {a, b} -> {a + g, b + g} end)
    |> Stream.take_while(fn {a, b} -> a in x_range and b in y_range end)
    |> Enum.to_list()
    |> IO.inspect()
    Enum.zip(sx1..sx2, )
  end

  defp intersections(
         {:diag, sx1..sx2//_, sy1..sy2//_, sg, sb},
         {:diag, tx1..tx2//_, ty1..ty2//_, tg, tb}
       )
       when sx1 < tx2 and tx1 < sx2 and sy1 < ty2 and ty1 < sy2 do
    {sg, tg, sb, tb} |> IO.inspect()
    x = div(tb - sb, 2)
    y = sg * x + sb

    [{x, y}]
  end

  defp intersections({:vert, sx, sy1..sy2//_}, {:hort, tx1..tx2//_, ty})
       when sx in tx1..tx2//1 and ty in sy1..sy2//1,
       do: [{sx, ty}]

  defp intersections({:hort, _, _} = s, {:vert, _, _} = t), do: intersections(t, s)

  defp intersections({:vert, sx, sy1..sy2//_}, {:diag, {a, b}, {c, d}, _, b})
       when sx in a..c//1 and sy1 < ty2 and ty1 < sy2,
       do: [{sx, sx + b}]

  defp intersections({:diag, _, _, _, _} = s, {:vert, _, _} = t), do: intersections(t, s)

  defp intersections({:hort, sx1..sx2//_, sy}, {:diag, tx1..tx2//_, ty1..ty2//_, _, b})
       when sy in ty1..ty2//1 and sx1 < tx2 and tx1 < sx2,
       do: [{sy + b, sy}]

  defp intersections({:diag, _, _, _, _} = s, {:hort, _, _} = t), do: intersections(t, s)

  defp intersections(_, _), do: []
end

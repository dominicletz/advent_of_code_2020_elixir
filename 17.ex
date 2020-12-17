#! /usr/bin/env elixir
defmodule Day do
  def memo_do(arg, fun) do
    case Process.get(arg) do
      nil ->
        ret = fun.(arg)
        Process.put(arg, ret)
        ret

      ret ->
        ret
    end
  end

  def map_field({field, neighbours}) do
    cnt = Enum.count(neighbours, fn n -> n end)

    case field do
      true -> cnt == 2 or cnt == 3
      false -> cnt == 3
    end
  end

  def reduce(fields, 0, _debug) do
    fields
  end

  def reduce(fields, n, debug) do
    new_fields = map_fields(fields)
    if debug, do: print(n - 1, new_fields)
    reduce(new_fields, n - 1, debug)
  end

  def print(n, fields) do
    {min_x, max_x, min_y, max_y, min_z, max_z} =
      Enum.reduce(Map.keys(fields), {0, 0, 0, 0, 0, 0}, fn {x, y, z},
                                                           {min_x, max_x, min_y, max_y, min_z,
                                                            max_z} ->
        {min(x, min_x), max(x, max_x), min(y, min_y), max(y, max_y), min(z, min_z), max(z, max_z)}
      end)

    IO.puts("Cycle #{-n}")

    for z <- min_z..max_z do
      IO.puts("z=#{z}")

      for y <- min_y..max_y do
        for x <- min_x..max_x do
          case fields[{x, y, z}] == true do
            true -> :io.format("#")
            false -> :io.format(".")
          end
        end

        :io.format("~n")
      end

      :io.format("~n")
    end
  end

  def map_fields(fields) do
    lookup = Map.new(fields)

    {new_field, neighbours} =
      Enum.reduce(fields, {%{}, []}, fn {pos, field}, {new_fields, ns} ->
        {neighbours, values} = neighbours(lookup, pos)
        value = memo_do({field, values}, &map_field/1)
        {Map.put(new_fields, pos, value), neighbours ++ ns}
      end)

    visited = MapSet.new(Map.keys(new_field))
    neighbours = MapSet.difference(MapSet.new(neighbours), visited)

    additional =
      Enum.reduce(neighbours, %{}, fn pos, add ->
        {_neighbours, values} = neighbours(lookup, pos)
        value = memo_do({false, values}, &map_field/1)

        if value == true do
          Map.put(add, pos, value)
        else
          add
        end
      end)

    Map.merge(new_field, additional)
  end

  def neighbours(lookup, {x, y, z}) do
    neighbours =
      Enum.flat_map(-1..1, fn zd ->
        [
          {-1, -1, zd},
          {+0, -1, zd},
          {+1, -1, zd},
          {-1, 0, zd},
          {+0, 0, zd},
          {+1, 0, zd},
          {-1, +1, zd},
          {+0, +1, zd},
          {+1, +1, zd}
        ]
      end)
      |> Enum.reject(fn pos -> pos == {0, 0, 0} end)
      |> Enum.map(fn {xd, yd, zd} -> {x + xd, y + yd, z + zd} end)

    values = Enum.map(neighbours, fn pos -> lookup[pos] == true end)
    {neighbours, values}
  end
end

File.read!("17.csv")
|> String.split("\n", trim: true)
|> Enum.with_index()
|> Enum.flat_map(fn {row, y} ->
  String.to_charlist(row)
  |> Enum.with_index()
  |> Enum.map(fn {c, x} -> {{x, y, 0}, c == ?#} end)
end)
|> Map.new()
|> Day.reduce(6, true)
|> Enum.count(fn {_pos, value} -> value end)
|> IO.inspect()

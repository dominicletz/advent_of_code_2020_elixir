#! /usr/bin/env elixir

defmodule Day11 do
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
    neighbours = Enum.reject(neighbours, fn n -> n == nil end)

    case field do
      true ->
        true

      :occ ->
        if Enum.count(neighbours, fn n -> n == :occ end) >= 4 do
          :emp
        else
          :occ
        end

      :emp ->
        if Enum.count(neighbours, fn n -> n == :occ end) == 0 do
          :occ
        else
          :emp
        end
    end
  end

  def reduce(fields, debug \\ false) do
    new_fields = map_fields(fields)
    if debug, do: print(new_fields)

    if new_fields != fields do
      reduce(new_fields, debug)
    else
      fields
    end
  end

  def print(fields) do
    Enum.reduce(fields, 0, fn {{_x, y}, f}, row ->
      ret =
        if y != row do
          :io.format("~n")
          y
        else
          row
        end

      case f do
        true -> :io.format(".")
        :occ -> :io.format("#")
        :emp -> :io.format("L")
      end

      ret
    end)

    :io.format("~n~n")
  end

  def map_fields(fields) do
    lookup = Map.new(fields)

    Enum.map(fields, fn {{x, y}, field} ->
      neighbours =
        [
          {x - 1, y - 1},
          {x + 0, y - 1},
          {x + 1, y - 1},
          {x - 1, y + 0},
          {x + 1, y + 0},
          {x - 1, y + 1},
          {x + 0, y + 1},
          {x + 1, y + 1}
        ]
        |> Enum.map(fn pos -> lookup[pos] end)

      {{x, y}, memo_do({field, neighbours}, &map_field/1)}
    end)
  end
end

File.read!("11.csv")
|> String.split("\n", trim: true)
|> Enum.with_index()
|> Enum.flat_map(fn {row, y} ->
  String.to_charlist(row)
  |> Enum.with_index()
  |> Enum.map(fn {c, x} -> {{x, y}, c == ?. || :emp} end)
end)
|> Day11.reduce()
|> Enum.count(fn {_, f} -> f == :occ end)
|> IO.inspect()

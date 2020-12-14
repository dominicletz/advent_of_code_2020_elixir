#!/usr/bin/env elixir
defmodule Day do
  def run() do
    [_, busses] = File.read!("13.csv")
    |> String.split("\n", trim: true)

    lines = String.split(busses, ",")
    |> Enum.with_index()
    |> Enum.reject(fn {line, _} -> line == <<"x">> end)
    |> Enum.map(fn {line, idx} ->
      line = String.to_integer(line)
      {line, idx}
    end)

    Stream.iterate(0, fn i -> i + 1 end)
    |> Enum.reduce_while({1, 1, lines}, fn _n, {inc, time, lines} ->
      Enum.reduce(lines, {inc, time + inc, []}, fn {line, idx}, {inc, time, lines} ->
        if rem(time + idx, line) == 0 do
          {inc * line, time, lines}
        else
          {inc, time, lines ++ [{line, idx}]}
        end
      end)
      |> case do
        {_inc, time, []} -> {:halt, time}
        other -> {:cont, other}
      end

    end)
    |> IO.inspect()
  end
end

Day.run()

#! /usr/bin/env elixir
defmodule Day do
  def run() do
    [time, busses] =
      File.read!("13.csv")
      |> String.split("\n", trim: true)

    time = String.to_integer(time)

    {wait, bus} =
      String.split(busses, ",")
      |> Enum.reject(fn line -> line == <<"x">> end)
      |> Enum.map(fn line ->
        line = String.to_integer(line)
        {line - rem(time, line), line}
      end)
      |> Enum.min()

    IO.inspect(wait * bus)
  end
end

Day.run()

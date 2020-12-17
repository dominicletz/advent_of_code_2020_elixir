#! /usr/bin/env elixir
defmodule Day12 do
  @north 0
  @east 1
  @south 2
  @west 3

  def run() do
    {_, east, north} =
      File.read!("12.csv")
      |> String.split("\n", trim: true)
      |> Enum.map(fn <<cmd, num::binary>> ->
        {cmd, String.to_integer(num)}
      end)
      |> Enum.reduce({@east, 0, 0}, fn {cmd, num}, {dir, east, north} ->
        cmd =
          cond do
            cmd != ?F -> cmd
            dir == @north -> ?N
            dir == @south -> ?S
            dir == @west -> ?W
            dir == @east -> ?E
          end

        case cmd do
          ?N -> {dir, east, north + num}
          ?S -> {dir, east, north - num}
          ?E -> {dir, east + num, north}
          ?W -> {dir, east - num, north}
          ?L -> {rem(dir + 4 - div(num, 90), 4), east, north}
          ?R -> {rem(dir + div(num, 90), 4), east, north}
        end
      end)

    result = abs(east) + abs(north)
    IO.inspect(result)
  end
end

Day12.run()

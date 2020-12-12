#!/usr/bin/env elixir
defmodule Day12 do
  def rot({east, north}, 0), do: {east, north}
  def rot({east, north}, count), do: rot({north, -east}, count - 1)

  def run() do
    {_, east, north} = File.read!("12.csv")
    |> String.split("\n", trim: true)
    |> Enum.map(fn <<cmd, num :: binary>> ->
      {cmd, String.to_integer(num)}
    end)
    |> Enum.reduce({{10, 1}, 0, 0}, fn {cmd, num}, {dir = {de, dn}, east, north} ->
      case cmd do
        ?F -> {dir, east + de*num, north + dn*num}
        ?N -> {{de, dn + num}, east, north}
        ?S -> {{de, dn - num}, east, north}
        ?E -> {{de + num, dn}, east, north}
        ?W -> {{de - num, dn}, east, north}
        ?L -> {rot(dir, rem(4 - div(num, 90), 4)), east, north}
        ?R -> {rot(dir, rem(div(num, 90), 4)), east, north}
      end
    end)

    result = abs(east) + abs(north)
    IO.inspect(result)
  end
end

Day12.run()

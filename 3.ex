#! /usr/bin/env elixir

map =
  File.read!("3.csv")
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    String.to_charlist(line)
    |> Enum.map(fn char -> char == ?# end)
  end)
  |> Enum.reduce({0, 0}, fn trees, {pos, count} ->
    if Enum.at(trees, rem(pos, length(trees))) do
      {pos + 3, count + 1}
    else
      {pos + 3, count}
    end
  end)

{_pos, result} = map
:io.format("~p~n", [result])

#!/usr/bin/env elixir
require Integer

map = File.read!("3.csv")
|> String.split("\n", trim: true)
|> Enum.map(fn line ->
  String.to_charlist(line)
    |> Enum.map(fn char -> char == ?# end)
end)
|> Enum.reduce(List.duplicate({0, 0}, 5), fn trees, slopes ->
  Enum.with_index(slopes)
  |> Enum.map(fn {{pos, count}, slope} ->
    nextpos = case slope do
      0 -> pos+1
      1 -> pos+3
      2 -> pos+5
      3 -> pos+7
      4 -> pos+0.5
    end
    if trunc(pos) == pos and Enum.at(trees, rem(trunc(pos), length(trees))) do
      {nextpos, count + 1}
    else
      {nextpos, count}
    end
  end)
end)

result = Enum.map(map, fn {_pos, count} -> count end)
  |> Enum.reduce(1, fn count, product -> count * product end)

:io.format("~p~n", [result])

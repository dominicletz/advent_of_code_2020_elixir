#!/usr/bin/env elixir
yes = MapSet.new('abcdefghijklmnopqrstuvwxyz')

File.read!("6.csv")
|> String.split("\n\n", trim: true)
|> Enum.map(fn group ->
  group = MapSet.new(String.to_charlist(group))
  MapSet.size(yes) - MapSet.size(MapSet.difference(yes, group))
end)
|> Enum.sum()
|> IO.inspect()

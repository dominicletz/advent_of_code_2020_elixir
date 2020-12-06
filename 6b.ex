#!/usr/bin/env elixir
yes = MapSet.new('abcdefghijklmnopqrstuvwxyz')

File.read!("6.csv")
|> String.split("\n\n", trim: true)
|> Enum.map(fn group ->
  group = String.split(group, "\n", trim: true)
    |> Enum.map(fn person -> MapSet.new(String.to_charlist(person)) end)
    |> Enum.reduce(yes, fn p, all -> MapSet.intersection(all, p) end)

  MapSet.size(yes) - MapSet.size(MapSet.difference(yes, group))
end)
|> Enum.sum()
|> IO.inspect()

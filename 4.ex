#!/usr/bin/env elixir
require Integer

must_have = MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
# optional = ["cid"]

result = File.read!("4.csv")
|> String.split("\n\n", trim: true)
|> Enum.map(fn record ->
  entries = String.replace(record, "\n", " ") |> String.split(" ")
    |> Enum.map(fn field -> hd(String.split(field, ":")) end)
    |> MapSet.new()

  MapSet.size(MapSet.difference(must_have, entries)) == 0
end)
|> Enum.count(fn valid -> valid end)

:io.format("~p~n", [result])

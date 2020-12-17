#! /usr/bin/env elixir

nums =
  File.read!("1.csv")
  |> String.split("\n", trim: true)
  |> Enum.map(fn num -> elem(Integer.parse(num), 0) end)

result =
  for x <- nums, y <- nums, x + y == 2020 do
    x * y
  end
  |> Enum.sum()
  |> div(2)

:io.format("~p~n", [result])

#!/usr/bin/env elixir

nums = File.read!("1.csv")
|> String.split("\n", trim: true)
|> Enum.map(fn num -> elem(Integer.parse(num), 0) end)

result = for x <- nums, y <- nums, z <- nums, x+y+z == 2020 do
  x*y*z
end
|> Enum.sum()
|> div(6)

:io.format("~p~n", [result])

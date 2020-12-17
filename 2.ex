#! /usr/bin/env elixir
import String

passwords =
  File.read!("2.csv")
  |> split("\n", trim: true)
  |> Enum.map(fn line ->
    [limit, <<letter, ":">>, password] = split(line, " ")
    [low, high] = split(limit, "-") |> Enum.map(&to_integer/1)
    count = Enum.count(String.to_charlist(password), fn c -> c == letter end)

    {password, count >= low and count <= high}
  end)

result =
  Enum.filter(passwords, fn {_password, valid} -> valid end)
  |> Enum.count()

:io.format("~p~n", [result])

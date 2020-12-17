#! /usr/bin/env elixir
import String

passwords =
  File.read!("2.csv")
  |> split("\n", trim: true)
  |> Enum.map(fn line ->
    [positions, <<letter, ":">>, password] = split(line, " ")
    positions = split(positions, "-") |> Enum.map(&to_integer/1)
    password = String.to_charlist(password)

    count =
      Enum.filter(positions, fn pos -> Enum.at(password, pos - 1) == letter end)
      |> Enum.count()

    {password, count == 1}
  end)

result =
  Enum.filter(passwords, fn {_password, valid} -> valid end)
  |> Enum.count()

# result = passwords
:io.format("~p~n", [result])

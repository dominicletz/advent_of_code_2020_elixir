#! /usr/bin/env elixir

defmodule Day10 do
  def permuations([]) do
    1
  end

  def permuations(arg) do
    case Process.get(arg) do
      nil ->
        ret = do_permuations(arg)
        Process.put(arg, ret)
        ret

      ret ->
        ret
    end
  end

  def do_permuations([jolt | rest]) do
    limit = jolt + 3

    case rest do
      [_, _, c | _] when c <= limit ->
        permuations(rest) + permuations(tl(rest)) + permuations(tl(tl(rest)))

      [_, c | _] when c <= limit ->
        permuations(rest) + permuations(tl(rest))

      _ ->
        permuations(rest)
    end
  end
end

("0\n" <> File.read!("10.csv"))
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)
|> Enum.sort()
|> Day10.permuations()
# |> Enum.reduce(1, fn x, prod -> x * prod end)
|> IO.inspect()

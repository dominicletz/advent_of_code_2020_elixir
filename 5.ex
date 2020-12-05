#!/usr/bin/env elixir
result = File.read!("5.csv")
|> String.split("\n", trim: true)
|> Enum.map(fn <<row :: binary-size(7), col :: binary-size(3)>> ->
  row = for <<c <- row>>, into: "" do
    if c == ?B do
      <<1::unsigned-size(1)>>
    else
      <<0::unsigned-size(1)>>
    end
  end
  <<row :: unsigned-size(7)>> = row

  col = for <<c <- col>>, into: "" do
    if c == ?R do
      <<1::unsigned-size(1)>>
    else
      <<0::unsigned-size(1)>>
    end
  end
  <<col :: unsigned-size(3)>> = col

  {row, col}
end)
|> Enum.map(fn {row, col} ->
  row * 8 + col
end)
|> Enum.max()

:io.format("~p~n", [result])

#!/usr/bin/env elixir
limit = 25

weak = File.read!("9.csv")
|> String.split("\n", trim: true)
|> Enum.reduce_while([], fn num, list ->
  num = String.to_integer(num)
  if length(list) < limit do
    {:cont, [num | list]}
  else
    sums = (for x <- list, y <- list, x != y, do: x + y) |> MapSet.new()

    if MapSet.member?(sums, num) do
      {:cont, Enum.take([num | list], limit)}
    else
      {:halt, num}
    end
  end
end)

leak = File.read!("9.csv")
|> String.split("\n", trim: true)
|> Enum.reduce_while([], fn num, list ->
  list = [String.to_integer(num) | list]
  if length(list) < 2 do
    {:cont, list}
  else
    case Enum.sum(list) do
      ^weak -> {:halt, list}
      too_small when too_small < weak -> {:cont, list}
      too_large when too_large > weak ->
        rest = Enum.reduce_while(list, list, fn _item, list ->
          if Enum.sum(list) <= weak do
            {:halt, list}
          else
            {:cont, Enum.take(list, length(list) - 1)}
          end
        end)
        if Enum.sum(rest) == weak do
          {:halt, rest}
        else
          {:cont, rest}
        end
    end
  end
end)

[Enum.min(leak), Enum.max(leak)]
|> Enum.sum()
|> IO.inspect()

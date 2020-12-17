#! /usr/bin/env elixir
limit = 25

File.read!("9.csv")
|> String.split("\n", trim: true)
|> Enum.reduce_while([], fn num, list ->
  num = String.to_integer(num)

  if length(list) < limit do
    {:cont, [num | list]}
  else
    sums = for(x <- list, y <- list, x != y, do: x + y) |> MapSet.new()

    if MapSet.member?(sums, num) do
      {:cont, Enum.take([num | list], limit)}
    else
      {:halt, num}
    end
  end
end)
|> IO.inspect()

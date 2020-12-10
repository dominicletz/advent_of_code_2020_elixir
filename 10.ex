#!/usr/bin/env elixir
{_, stats} = File.read!("10.csv")
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)
|> Enum.sort()
|> Enum.reduce({0, %{3 => 1}}, fn jolt, {prev, stats} ->
  delta = jolt - prev
  stats = Map.update(stats, delta, 1, fn i -> i + 1 end)
  {jolt, stats}
end)


IO.inspect(stats[3] * stats[1])

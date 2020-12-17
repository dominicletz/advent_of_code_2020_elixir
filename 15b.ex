#! /usr/bin/env elixir
defmodule Day do
  def run() do
    [nums] =
      File.read!("15.csv")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        String.split(row, ",") |> Enum.map(&String.to_integer/1)
      end)

    map =
      Enum.with_index(nums)
      |> Enum.take(length(nums) - 1)
      |> Enum.reduce(%{}, fn {num, i}, map ->
        Map.put(map, num, {i, 1})
      end)

    {_, ret} =
      Enum.reduce(length(nums)..(30_000_000 - 1), {map, List.last(nums)}, fn turn, {map, next} ->
        if rem(turn, 100_000) == 0 do
          IO.puts("turn #{turn}")
        end

        num =
          case map[next] do
            nil -> 0
            {pos, _count} -> turn - pos - 1
          end

        {Map.update(map, next, {turn - 1, 1}, fn {_turn, count} -> {turn - 1, count + 1} end),
         num}
      end)

    IO.inspect(ret)
  end
end

Day.run()

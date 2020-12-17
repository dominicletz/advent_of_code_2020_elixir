#! /usr/bin/env elixir
defmodule Day do
  import Bitwise

  def run() do
    instr =
      File.read!("14.csv")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row -> String.split(row, " = ") end)

    {_, _, map} =
      Enum.reduce(instr, {0, 0, %{}}, fn [assign, num], {mask0, mask1, map} ->
        case assign do
          "mask" ->
            {mask0, mask1, _} =
              String.to_charlist(num)
              |> Enum.reverse()
              |> Enum.reduce({0, 0, 1}, fn x, {mask0, mask1, bit} ->
                case x do
                  ?X -> {mask0, mask1, bit * 2}
                  ?1 -> {mask0, mask1 ||| bit, bit * 2}
                  ?0 -> {mask0 ||| bit, mask1, bit * 2}
                end
              end)

            {mask0, mask1, map}

          _ ->
            ["mem", index] = String.split(String.trim_trailing(assign, "]"), "[")
            index = String.to_integer(index)
            num = String.to_integer(num)
            value = (num ||| mask1) &&& Bitwise.bnot(mask0)
            {mask0, mask1, Map.put(map, index, value)}
        end
      end)

    map
    |> Map.values()
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day.run()

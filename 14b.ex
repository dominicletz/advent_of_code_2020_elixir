#! /usr/bin/env elixir
defmodule Day do
  def values({}), do: []
  def values({a, b}), do: values(a) ++ values(b)
  def values(v), do: [v]

  def put(_, [], value) do
    value
  end

  def put({}, [x | rest], value) do
    next = put({}, rest, value)

    case x do
      ?1 -> {{}, next}
      ?0 -> {next, {}}
      ?X -> {next, next}
    end
  end

  def put({zero, one}, [?0 | rest], value) do
    {put(zero, rest, value), one}
  end

  def put({zero, one}, [?1 | rest], value) do
    {zero, put(one, rest, value)}
  end

  def put({zero, one}, [?X | rest], value) do
    {put(zero, rest, value), put(one, rest, value)}
  end

  def run() do
    instr =
      File.read!("14.csv")
      |> String.split("\n", trim: true)
      |> Enum.map(fn row -> String.split(row, " = ") end)

    mask = "000000000000000000000000000000000000"

    {_, map} =
      Enum.reduce(instr, {mask, {}}, fn [assign, num], {mask, map} ->
        case assign do
          "mask" ->
            mask = String.to_charlist(num)
            {mask, map}

          _ ->
            ["mem", index] = String.split(String.trim_trailing(assign, "]"), "[")

            index =
              String.to_integer(index)
              |> Integer.to_string(2)
              |> String.pad_leading(36, "0")
              |> String.to_charlist()
              |> Enum.zip(mask)
              |> Enum.map(fn {addr, maskbit} ->
                case maskbit do
                  ?0 -> addr
                  ?1 -> ?1
                  ?X -> ?X
                end
              end)

            value = String.to_integer(num)
            {mask, put(map, index, value)}
        end
      end)

    values(map)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day.run()

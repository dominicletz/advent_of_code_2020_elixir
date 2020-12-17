#! /usr/bin/env elixir

defmodule Day8 do
  def reduce(instr, ptr, state) do
    case Map.pop(instr, ptr) do
      {{"nop", _}, instr} -> reduce(instr, ptr + 1, state)
      {{"acc", n}, instr} -> reduce(instr, ptr + 1, state + n)
      {{"jmp", n}, instr} -> reduce(instr, ptr + n, state)
      {nil, _instr} -> state
    end
  end
end

instr =
  File.read!("8.csv")
  |> String.split("\n", trim: true)
  |> Enum.with_index()
  |> Enum.map(fn {row, idx} ->
    [op, num] = String.split(row)
    num = String.to_integer(num)
    {idx, {op, num}}
  end)
  |> Map.new()

Day8.reduce(instr, 0, 0)
|> IO.inspect()

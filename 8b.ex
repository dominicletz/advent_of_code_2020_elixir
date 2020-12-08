#!/usr/bin/env elixir

defmodule Day8 do
  def reduce(instr, ptr, state, changed) do
    case Map.pop(instr, ptr) do
      {{"nop", n}, instr} -> reduce(instr, ptr + 1, state, changed) || (unless changed, do: reduce(instr, ptr + n, state, true))
      {{"jmp", n}, instr} -> reduce(instr, ptr + n, state, changed) || (unless changed, do: reduce(instr, ptr + 1, state, true))
      {{"acc", n}, instr} -> reduce(instr, ptr + 1, state + n, changed)
      {nil, _instr} -> false
      {:fin, _instr} -> state
    end
  end
end

instr = File.read!("8.csv")
|> String.split("\n", trim: true)
|> Enum.with_index()
|> Enum.map(fn {row, idx} ->
  [op, num] = String.split(row)
  num = String.to_integer(num)
  {idx, {op, num}}
end)
|> Map.new()

instr = Map.put(instr, map_size(instr), :fin)
Day8.reduce(instr, 0, 0, false)
|> IO.inspect()

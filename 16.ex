#! /usr/bin/env elixir
defmodule Day do
  def run() do
    [attributes, _ticket, nearby] =
      File.read!("16.csv")
      |> String.split("\n\n", trim: true)

    attributes =
      String.split(attributes, "\n", trim: true)
      |> Enum.flat_map(fn row ->
        [_label, filter] = String.split(row, ": ")

        String.split(filter, " or ")
        |> Enum.flat_map(fn range ->
          [min, max] = Enum.map(String.split(range, "-"), &String.to_integer/1)
          min..max
        end)
      end)

    String.split(nearby, "\n", trim: true)
    |> Enum.drop(1)
    |> Enum.flat_map(fn row ->
      String.split(row, ",") |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reject(fn num -> Enum.member?(attributes, num) end)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day.run()

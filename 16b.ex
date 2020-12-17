#! /usr/bin/env elixir
defmodule Day do
  def run() do
    [attributes, my_ticket, nearby] =
      File.read!("16.csv")
      |> String.split("\n\n", trim: true)

    attributes =
      String.split(attributes, "\n", trim: true)
      |> Enum.map(fn row ->
        [label, filter] = String.split(row, ": ")

        range =
          String.split(filter, " or ")
          |> Enum.flat_map(fn range ->
            [min, max] = Enum.map(String.split(range, "-"), &String.to_integer/1)
            min..max
          end)

        {label, range}
      end)

    all_attrs = Enum.flat_map(attributes, fn {_label, values} -> values end)

    my_ticket =
      String.split(my_ticket, "\n", trim: true)
      |> Enum.drop(1)
      |> Enum.flat_map(fn row ->
        String.split(row, ",") |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.with_index()
      |> Enum.map(fn {num, key} -> {key, num} end)
      |> Map.new()

    cols =
      String.split(nearby, "\n", trim: true)
      |> Enum.drop(1)
      |> Enum.map(fn row ->
        String.split(row, ",") |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.filter(fn row -> Enum.all?(row, fn num -> Enum.member?(all_attrs, num) end) end)
      |> Enum.reduce(%{}, fn row, cols ->
        Enum.with_index(row)
        |> Enum.reduce(cols, fn {num, i}, cols ->
          Map.update(cols, i, [num], fn nums -> nums ++ [num] end)
        end)
      end)

    attributes
    |> Enum.map(fn {label, range} -> {label, range, []} end)
    |> reduce(cols, [])
    |> Enum.filter(fn {label, _range, _match} -> String.starts_with?(label, "departure") end)
    |> Enum.map(fn {_label, _range, [match]} -> my_ticket[match] end)
    |> Enum.reduce(1, fn x, prod -> x * prod end)
    |> IO.inspect()
  end

  def reduce([], _cols, ret) do
    ret
  end

  def reduce(attributes, cols, ret) do
    unmatched =
      Enum.map(attributes, fn {label, range, _matches} ->
        matches =
          Enum.filter(cols, fn {_i, values} ->
            Enum.all?(values, fn num -> Enum.member?(range, num) end)
          end)
          |> Enum.map(fn {i, _values} -> i end)

        {label, range, matches}
      end)

    min =
      {_label, _range, candidates} =
      Enum.min(unmatched, fn {_la, _ra, matches_a}, {_lb, _rb, matches_b} ->
        length(matches_a) < length(matches_b)
      end)

    unmatched = Enum.reject(unmatched, fn e -> e == min end)

    Enum.find_value(candidates, fn candidate ->
      cols = Map.drop(cols, [candidate])
      reduce(unmatched, cols, ret ++ [min])
    end)
  end
end

Day.run()

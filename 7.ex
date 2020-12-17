#! /usr/bin/env elixir

my_bag = "shiny gold"

defmodule Day7 do
  def parse(rest) do
    case rest do
      ~w(no other bags.) -> []
      [_count, shade, color, _bags] -> [shade <> " " <> color]
      [_count, shade, color, _bags | rest] -> [shade <> " " <> color | parse(rest)]
    end
  end

  def contain(_tree, nil, _my_bag), do: false
  def contain(_tree, [], _my_bag), do: false

  def contain(tree, [node | nodes], bag) do
    node == bag or
      contain(tree, tree[node], bag) or
      contain(tree, nodes, bag)
  end
end

tree =
  File.read!("7.csv")
  |> String.split("\n", trim: true)
  |> Enum.map(fn row ->
    [shade, color, "bags", "contain" | rest] = String.split(row)

    key = shade <> " " <> color
    contents = Day7.parse(rest)
    {key, contents}
  end)
  |> Map.new()

Enum.filter(tree, fn {_key, nodes} ->
  Day7.contain(tree, nodes, my_bag)
end)
|> Enum.count()
|> IO.inspect()

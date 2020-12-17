#! /usr/bin/env elixir

my_bag = "shiny gold"

defmodule Day7 do
  def parse(rest) do
    case rest do
      ~w(no other bags.) -> []
      [count, shade, color, _bags] -> [{shade <> " " <> color, count}]
      [count, shade, color, _bags | rest] -> [{shade <> " " <> color, count} | parse(rest)]
    end
  end

  def count(_tree, nil), do: 0
  def count(_tree, []), do: 0

  def count(tree, [{node, cnt} | nodes]) do
    cnt = String.to_integer(cnt)
    cnt + cnt * count(tree, tree[node]) + count(tree, nodes)
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

Day7.count(tree, tree[my_bag])
|> IO.inspect()

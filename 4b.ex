#! /usr/bin/env elixir
must_have = MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

check_int = fn int, min, max ->
  case Integer.parse(int) do
    {num, ""} -> num >= min and num <= max
    _ -> false
  end
end

result =
  File.read!("4.csv")
  |> String.split("\n\n", trim: true)
  |> Enum.map(fn record ->
    entries =
      String.replace(record, "\n", " ")
      |> String.split(" ")
      |> Enum.map(fn field ->
        field = String.split(field, ":")

        case field do
          ["byr", <<year::binary-size(4)>>] -> check_int.(year, 1920, 2002)
          ["iyr", <<year::binary-size(4)>>] -> check_int.(year, 2010, 2020)
          ["eyr", <<year::binary-size(4)>>] -> check_int.(year, 2020, 2030)
          ["hgt", <<cm::binary-size(3), "cm">>] -> check_int.(cm, 150, 193)
          ["hgt", <<inch::binary-size(2), "in">>] -> check_int.(inch, 59, 76)
          ["hcl", <<"#", hex::binary-size(6)>>] -> Regex.match?(~r/^[0-9a-f]+$/, hex)
          ["ecl", color] -> Enum.member?(colors, color)
          ["pid", <<num::binary-size(9)>>] -> Regex.match?(~r/^[0-9]+$/, num)
          _other -> false
        end and hd(field)
      end)
      |> MapSet.new()

    MapSet.size(MapSet.difference(must_have, entries)) == 0
  end)
  |> Enum.count(fn valid -> valid end)

:io.format("~p~n", [result])

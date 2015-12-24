defmodule CharacterGenerator.Main do
  def main(args), do: args |> parse_args |> _main

  defp _main(args) when map_size(args) < 1, do: _main %{points: 8*3, rank: true}
  defp _main(args) do
    seed(args)
    stats = stats(args)
    result = CharacterGenerator.point_buy(points(args), stats)
      |> CharacterGenerator.multiply(multiply(args))
      |> CharacterGenerator.add(bonus(args))
      |> roll(args)
      |> point_display(args)
    stats
      |> Enum.zip(result)
      |> Enum.each(fn {key, value} -> IO.puts "#{key}: #{value}" end)
  end

  defp roll(values, %{roll: roll}) do
    # format: xdy xdy+c xdy-c xdy+-c
    ~r/(?<x>\d+)d(?<y>\d+)(?:[+]?(?<c>-?\d+))?/
      |> Regex.named_captures(roll)
      |> _roll(values)
  end
  defp roll(values, _args), do: values
  defp _roll(%{"x" => x, "y" => y, "c" => ""}, values) do
    %{"x" => x, "y" => y, "c" => "0"} |> _roll(values)
  end
  defp _roll(%{"x" => x, "y" => y, "c" => c}, values) do
    x = String.to_integer x
    y = String.to_integer y
    c = String.to_integer c
    values
      |> CharacterGenerator.roll(x, y, c)
  end
  defp _roll(_caputure, values), do: values

  defp points(%{points: points}), do: points
  defp points(_), do: 0

  defp multiply(%{multiply: multiply}), do: multiply
  defp multiply(_), do: 1

  # This commented out version might be able to be used for a printable seed
  # defp seed(%{seed: seed}), do: String.split(seed, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple |> :random.seed
  defp seed(%{seed: seed}) do
    IO.puts "Seed: #{seed}"
    :random.seed(seed)
  end
  defp seed(_), do: :random.seed(:os.timestamp)

  defp stats(%{stats: stats}), do: String.split(stats, ",") |> Enum.map(&String.to_atom/1)
  defp stats(_), do: CharacterGenerator.default_keys

  defp bonus(%{bonus: bonus}), do: String.split(bonus, ",") |> Enum.map(&String.to_integer/1)
  defp bonus(_), do: []

  defp point_display(list, %{rank: true}), do: list |> CharacterGenerator.rank
  defp point_display(list, %{percent: true}), do: list |> CharacterGenerator.percent
  defp point_display(list, %{numeric: true}), do: list
  defp point_display(list, _), do: point_display(list, %{numeric: true})

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      strict:
        [stats: :string,
         bonus: :string,
         points: :integer,
         rank: :boolean,
         percent: :boolean,
         numeric: :boolean,
         seed: :integer,
         multiply: :integer,
         roll: :string]
    )
    options |> Enum.into(%{})
  end
end


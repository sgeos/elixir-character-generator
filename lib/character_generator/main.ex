defmodule CharacterGenerator.Main do
  def main(args), do: args |> parse_args |> _main

  defp _main([points: points]) do
    :random.seed(:os.timestamp)
    CharacterGenerator.default_keys
      |> Enum.zip(CharacterGenerator.point_buy(points)
      |> CharacterGenerator.rank)
      |> Enum.each(fn {key, value} -> IO.puts "#{key}: #{value}" end)
  end
  defp _main(_), do: _main [points: 8*3]

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
      strict: [points: :integer]
    )
    options
  end
end


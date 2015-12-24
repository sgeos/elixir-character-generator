defmodule CharacterGenerator.Mixfile do
  use Mix.Project

  def project do
    [app: :character_generator,
     version: "0.0.1",
     elixir: "~> 1.1",
     escript: [main_module: CharacterGenerator.Main],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # This is a somewhat fragile way of handling an dual escript application project
  # May require touching mix.exs to toggle between escript and application
  def application do
    applications = [:logger]
    mod = {CharacterGenerator.Application, []}
    case :init.get_plain_arguments |> Enum.any?(&(&1=='escript.build')) do
      true ->
        [applications: applications]
      _ ->
        [applications: applications, mod: mod]
    end
  end

  defp deps do
    []
  end
end


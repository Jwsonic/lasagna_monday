defmodule Feeder.MixProject do
  use Mix.Project

  def project do
    [
      app: :feeder,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger] ++ apps(Mix.env()),
      mod: {Feeder.Application, []},
      extra_applications: [:logger]
    ]
  end

  def apps(:test), do: [:timex]

  def apps(_), do: [:tzdata, :timex, :elixir_ale, :nerves_time]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_ale, "~> 1.2"},
      {:timex, "~> 3.0"},
      {:tzdata, "~> 0.5.19"},
      {:nerves_time, "~> 0.2"}
    ]
  end
end

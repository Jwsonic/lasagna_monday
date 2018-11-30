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
    Mix.env() |> apps()
  end

  defp apps(:prod) do
    [mod: {Feeder.Application, []}, extra_applications: [:logger]]
  end

  defp apps(_) do
    [extra_applications: [:logger]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_ale, "~> 1.2"},
      {:timex, "~> 3.0"}
    ]
  end
end

defmodule Feeder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Feeder.Supervisor]

    Application.get_env(:feeder, :env) |> children() |> Supervisor.start_link(opts)
  end

  defp children(:test), do: []

  defp children(_env) do
    [
      %{
        id: Feeder.Motor,
        start: {Feeder.Motor, :start_link, []}
      },
      %{
        id: Feeder.Scheduler,
        start: {Feeder.Scheduler, :start_link, []}
      }
    ]
  end
end

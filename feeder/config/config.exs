# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

env = Mix.env()

config :feeder, env: env

if env != :test do
  config :tzdata, :data_dir, "/root/elixir_tzdata_data"
end

config :feeder, Feeder.Scheduler, timezone: "America/Los_Angeles"

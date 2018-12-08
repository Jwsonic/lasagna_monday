defmodule Feeder.Scheduler do
  use Quantum.Scheduler,
    otp_app: :feeder

  alias Crontab.CronExpression
  alias Feeder.Motor
  alias Feeder.TimesManager
  alias Quantum.Job
  alias Timex.Timezone

  require Logger

  @impl true
  def init(config) do
    jobs =
      TimesManager.get_times()
      |> Enum.map(&build_job(&1, config))

    Logger.info("Scheduling: #{inspect(jobs)}")

    Keyword.put(config, :jobs, jobs)
  end

  @spec build_job(Time.t(), Keyword.t()) :: Job.t()
  def build_job(time, config) do
    schedule = time_to_cron(time)

    tz = Timezone.local() |> Timezone.name_of()

    config
    |> Job.new()
    |> Job.set_schedule(schedule)
    |> Job.set_timezone(tz)
    |> Job.set_task(fn -> Motor.turn_one_rotation() end)
  end

  @spec time_to_cron(Time.t()) :: String.t()
  def time_to_cron(%Time{hour: hour, minute: minute, second: second}) do
    %CronExpression{second: [second], minute: [minute], hour: [hour], extended: true}
  end
end

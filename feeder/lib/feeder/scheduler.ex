defmodule Feeder.Scheduler do
  use Quantum.Scheduler,
    otp_app: :feeder

  alias Crontab.CronExpression
  alias Feeder.Motor
  alias Feeder.TimesManager
  alias Quantum.Job
  alias Quantum.RunStrategy.Local
  alias Timex.Timezone

  require Logger

  def schedule(%Time{} = time) do
    schedule = time_to_cron(time)
    tz = Timezone.local() |> Timezone.name_of()

    new_job()
    |> Job.set_schedule(schedule)
    |> Job.set_timezone(tz)
    |> Job.set_run_strategy(Local)
    |> Job.set_task(&Motor.turn_one_rotation/0)
    |> add_job()
  end

  @spec time_to_cron(Time.t()) :: String.t()
  def time_to_cron(%Time{hour: hour, minute: minute}) do
    %CronExpression{minute: [minute], hour: [hour]}
  end
end

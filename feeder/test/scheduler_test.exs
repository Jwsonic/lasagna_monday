defmodule SchedulerTest do
  use ExUnit.Case

  import Crontab.CronExpression

  alias Feeder.Scheduler

  describe "Scheduler" do
    test "time_to_cron/1 returns the time as a daily crontab" do
      assert Scheduler.time_to_cron(~T[07:00:00]) == ~e[0 7 *]

      assert Scheduler.time_to_cron(~T[12:30:00]) == ~e[30 12 *]

      assert Scheduler.time_to_cron(~T[16:25:11]) == ~e[25 16 *]
    end
  end
end

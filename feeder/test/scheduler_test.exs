defmodule SchedulerTest do
  use ExUnit.Case

  import Crontab.CronExpression

  alias Feeder.Scheduler

  describe "Scheduler" do
    test "time_to_cron/1 returns the time as a daily crontab" do
      assert Scheduler.time_to_cron(~T[07:00:00]) == ~e[0 0 7 *]e

      assert Scheduler.time_to_cron(~T[12:30:00]) == ~e[0 30 12 *]e

      assert Scheduler.time_to_cron(~T[16:25:11]) == ~e[11 25 16 *]e
    end
  end
end

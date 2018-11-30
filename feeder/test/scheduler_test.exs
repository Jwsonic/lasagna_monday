defmodule SchedulerTest do
  use ExUnit.Case

  alias Feeder.Scheduler

  @seven_am Timex.now() |> Timex.set(time: ~T[07:00:00])
  @noon Timex.now() |> Timex.set(time: ~T[12:00:00])
  @four_pm Timex.now() |> Timex.set(time: ~T[14:00:00])

  test "next_time/2 gives time time today if it's in the future " do
    assert Scheduler.next_time(@noon, @seven_am) == @noon
    assert Scheduler.next_time(@four_pm, @noon) == @four_pm
  end

  test "next_time/2 gives the time tomorrow if it's in the past" do
    assert Scheduler.next_time(@seven_am, @noon) == Timex.shift(@seven_am, days: 1)
    assert Scheduler.next_time(@noon, @four_pm) == Timex.shift(@noon, days: 1)
  end
end

defmodule SchedulerTest do
  use ExUnit.Case

  alias Feeder.Scheduler

  @seven_am Timex.local() |> Timex.set(time: ~T[07:00:00])
  @noon Timex.local() |> Timex.set(time: ~T[12:00:00])
  @four_pm Timex.local() |> Timex.set(time: ~T[14:00:00])

  test "next_time/2 gives time time today if it's in the future " do
    assert Timex.equal?(Scheduler.next_time(~T[12:00:00], @seven_am), @noon)
    assert Timex.equal?(Scheduler.next_time(~T[14:00:00], @noon), @four_pm)
  end

  test "next_time/2 gives the time tomorrow if it's in the past" do
    assert Timex.equal?(Scheduler.next_time(~T[07:00:00], @noon), Timex.shift(@seven_am, days: 1))
    assert Timex.equal?(Scheduler.next_time(~T[12:00:00], @four_pm), Timex.shift(@noon, days: 1))
  end
end

defmodule SchedulerTest do
  use ExUnit.Case

  alias Feeder.Scheduler

  describe "Scheduler" do
    test "schedules feedings at the proper time" do
      hour_from_now =
        Timex.local()
        |> Timex.shift(hours: 1)

      {:noreply, state} = Scheduler.handle_info({:schedule, hour_from_now}, MapSet.new())

      assert MapSet.member?(state, hour_from_now)
    end
  end
end

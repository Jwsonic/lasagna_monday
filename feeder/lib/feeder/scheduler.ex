defmodule Feeder.Scheduler do
  use GenServer

  alias Feeder.Motor
  alias Timex.Interval

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_init) do
    schedule_for(~T[07:00:00])
    schedule_for(~T[12:00:00])
    schedule_for(~T[16:00:00])
    schedule_for(~T[20:00:00])

    {:ok, {}}
  end

  def schedule_for(time) do
    delay = next_time(time)
    Process.send_after(__MODULE__, time, delay)
  end

  def handle_info(%Time{} = time, state) do
    Motor.turn_one_rotation()

    schedule_for(time)

    {:noreply, state}
  end

  def next_time(%Time{} = time) do
    now = Timex.Timezone.Local.lookup() |> Timex.now()
    now |> Timex.set(time: time) |> next_time(now)
  end

  def next_time(%DateTime{} = time_today, %DateTime{} = now) when time_today < now do
    Timex.shift(time_today, days: 1)
  end

  def next_time(%DateTime{} = time_today, %DateTime{}) do
    time_today
  end
end

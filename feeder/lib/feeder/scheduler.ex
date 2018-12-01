defmodule Feeder.Scheduler do
  use GenServer

  alias Feeder.Motor

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_init) do
    schedule(~T[07:00:00])
    schedule(~T[12:00:00])
    schedule(~T[16:00:00])
    schedule(~T[20:00:00])

    {:ok, {}}
  end

  def schedule(time) do
    delay = time |> next_time() |> Time.diff(Timex.local(), :millisecond)

    Process.send_after(__MODULE__, {:turn, time}, delay)
  end

  def next_time(%Time{} = time, now \\ nil) do
    feed_time = Timex.local() |> Timex.set(time: time)
    now = now || Timex.local()

    # Check if feed time already happened today
    case Timex.before?(now, feed_time) do
      true -> feed_time
      false -> Timex.shift(feed_time, days: 1)
    end
  end

  ####
  # Callbacks
  ####

  @impl true
  def handle_info({:turn, time}, state) do
    Motor.turn_one_rotation()

    schedule(time)

    {:noreply, state}
  end
end

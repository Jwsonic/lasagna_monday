defmodule Feeder.Scheduler do
  use GenServer

  alias Feeder.Motor

  require Logger

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    {:ok, MapSet.new()}
  end

  @spec schedule(Time.t() | DateTime.t()) :: :ok
  def schedule(time) do
    Process.send(__MODULE__, {:schedule, time}, [])
  end

  @impl true
  def handle_info({:schedule, %Time{hour: hour, minute: minute}}, state) do
    Timex.local()
    |> Timex.beginning_of_day()
    |> Timex.shift(hours: hour, minutes: minute)
    |> maybe_tomorrow()
    |> schedule()

    {:noreply, state}
  end

  @impl true
  def handle_info({:schedule, %DateTime{} = feed_time}, state) do
    if feed_time in state do
      Logger.info("#{feed_time} already scheduled. Skipping.")

      {:noreply, state}
    else
      new_state = MapSet.put(state, feed_time)

      offset = feed_time |> Timex.diff(Timex.local(), :milliseconds)

      Logger.info("Scheduling #{feed_time} in #{offset} ms.")

      Process.send_after(__MODULE__, {:feed, feed_time}, offset)

      {:noreply, new_state}
    end
  end

  @impl true
  def handle_info({:feed, feed_time}, state) do
    Logger.info("Feeding time!")

    Motor.turn_one_rotation()

    state = MapSet.delete(state, feed_time)

    # Schedule tomorrow's feeding for this time
    feed_time
    |> Timex.shift(days: 1)
    |> schedule()

    {:noreply, state}
  end

  defp maybe_tomorrow(datetime) do
    if Timex.before?(datetime, Timex.local()) do
      Timex.shift(datetime, days: 1)
    else
      datetime
    end
  end
end

defmodule Feeder.TimeSync do
  use GenServer

  require Logger

  alias Feeder.{Scheduler, TimesManager}
  alias Nerves.Time

  @check_timeout 1_000

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    Process.send(__MODULE__, :check, [])

    {:ok, false}
  end

  @impl true
  def handle_info(:check, true) do
    {:noreply, true}
  end

  @impl true
  def handle_info(:check, false) do
    if Time.synchronized?() do
      schedule()

      {:noreply, true}
    else
      Logger.info("Time out of sync. Trying again in #{@check_timeout}.")

      Process.send_after(__MODULE__, :check, @check_timeout)

      {:noreply, false}
    end
  end

  defp schedule() do
    Logger.info("Scheduling feedings.")

    TimesManager.get_times()
    |> Enum.each(&Scheduler.schedule/1)
  end
end

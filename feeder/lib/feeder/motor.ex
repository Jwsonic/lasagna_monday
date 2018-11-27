defmodule Feeder.Motor do
  @moduledoc """
  Controls the feeder motors
  """
  use GenServer

  alias ElixirALE.GPIO

  @pin 18

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def stop_turn() do
    Process.send(__MODULE__, :stop, [])
  end

  # Turn the motor for time in milliseconds
  def turn_for(time) when is_integer(time) and time > 0 do
    GenServer.call(__MODULE__, {:start, time})
  end

  @impl true
  def init(_init) do
    {:ok, pid} = GPIO.start_link(@pin, :output, start_value: 0)

    {:ok, {pid, 0}}
  end

  # We're already turning the motor, so skip this call
  def handle_call({:start, _seconds}, _from, {_pid, 1} = state) do
    {:reply, {:error, "The feeder is already turning."}, state}
  end

  def handle_call({:start, time}, _from, {pid, 0}) do
    :ok = GPIO.write(pid, 1)

    Process.send_after(__MODULE__, :stop, time)

    {:reply, :ok, {pid, 1}}
  end

  # Stopping when we're stoped is a no-op
  def handle_info(:stop, {pid, 0}), do: {:noreply, {pid, 0}}

  def handle_info(:stop, {pid, 1}) do
    :ok = GPIO.write(pid, 0)

    {:noreply, {pid, 0}}
  end
end

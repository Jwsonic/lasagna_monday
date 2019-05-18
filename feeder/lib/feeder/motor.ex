defmodule Feeder.Motor do
  @moduledoc """
  Controls the feeder motors
  """
  use GenServer

  alias ElixirALE.GPIO

  require Logger

  @direction_a_pin 23
  @direction_b_pin 24
  @pin 25

  @one_rotation 2_500

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

  def turn_one_rotation(), do: turn_for(@one_rotation)

  # Callbacks

  @impl true
  def init(_init) do
    {:ok, _} = GPIO.start_link(@direction_a_pin, :output, start_value: 1)
    {:ok, _} = GPIO.start_link(@direction_b_pin, :output, start_value: 0)
    {:ok, pid} = GPIO.start_link(@pin, :output, start_value: 0)

    {:ok, {pid, 0}}
  end

  # We're already turning the motor, so skip this call
  @impl true
  def handle_call({:start, _seconds}, _from, {_pid, 1} = state) do
    {:reply, {:error, "The feeder is already turning."}, state}
  end

  @impl true
  def handle_call({:start, time}, _from, {pid, 0}) do
    Logger.info("Turning!")
    :ok = GPIO.write(pid, 1)

    Process.send_after(__MODULE__, :stop, time)

    {:reply, :ok, {pid, 1}}
  end

  # Stopping when we're stoped is a no-op
  @impl true
  def handle_info(:stop, {pid, 0}), do: {:noreply, {pid, 0}}

  @impl true
  def handle_info(:stop, {pid, 1}) do
    :ok = GPIO.write(pid, 0)

    {:noreply, {pid, 0}}
  end
end

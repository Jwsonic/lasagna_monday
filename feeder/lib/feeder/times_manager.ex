defmodule Feeder.TimesManager do
  @moduledoc """
  Data layer for feeding times. Currently not backed by anything.
  """

  def get_times() do
    [
      ~T[07:00:00],
      ~T[12:00:00],
      ~T[16:00:00],
      ~T[20:00:00]
    ]
  end
end

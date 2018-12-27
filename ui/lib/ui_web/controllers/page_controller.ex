defmodule UiWeb.PageController do
  use UiWeb, :controller

  alias Feeder.Motor

  def index(conn, _params) do
    render(conn, "index.html", token: get_csrf_token())
  end

  def click(conn, params) do
    conn
    |> handle_turn(params)
    |> render("index.html", token: get_csrf_token())
  end

  defp handle_turn(conn, %{"turn" => "full"}) do
    Motor.turn_one_rotation()
    put_flash(conn, :info, "Full turn")
  end

  defp handle_turn(conn, %{"turn" => "second"}) do
    Motor.turn_for(1_000)
    put_flash(conn, :info, "Turning for a second")
  end

  defp handle_turn(conn, %{"turn" => "half"}) do
    Motor.turn_for(500)
    put_flash(conn, :info, "Turning for a half second")
  end

  defp handle_turn(conn, _params), do: conn
end

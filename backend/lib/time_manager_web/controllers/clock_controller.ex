defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeTracking
  alias TimeManager.TimeTracking.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index_by_user(conn, %{"userID" => user_id}) do
    clocks = TimeTracking.list_clocks_by_user(user_id)
    render(conn, :index, clocks: clocks)
  end

  def toggle(conn, %{"userID" => user_id}) do
    with {:ok, %Clock{} = clock} <- TimeTracking.toggle_clock(user_id) do
      conn
      |> put_status(:created)
      |> render(:show, clock: clock)
    end
  end
end
defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.TimeTracking
  alias TimeManager.TimeTracking.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index_by_user(conn, %{"userID" => user_id} = params) do
    working_times = TimeTracking.list_working_times_by_user(user_id, params)
    render(conn, :index, workingtimes: working_times)
  end

  def show_by_user(conn, %{"userID" => user_id, "id" => id}) do
    working_time = TimeTracking.get_working_time_for_user!(user_id, id)
    render(conn, :show, working_time: working_time)
  end

  def create_for_user(conn, %{"userID" => user_id} = params) do
    attrs = Map.get(params, "working_time", %{})

    with {:ok, %WorkingTime{} = working_time} <- TimeTracking.create_working_time_for_user(user_id, attrs) do
      conn
      |> put_status(:created)
      |> render(:show, working_time: working_time)
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = TimeTracking.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- TimeTracking.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = TimeTracking.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- TimeTracking.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
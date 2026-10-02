defmodule TimeManagerWeb.FeedbackController do
  use TimeManagerWeb, :controller

  alias TimeManager.Feedbacks
  alias TimeManager.Feedbacks.Feedback

  action_fallback TimeManagerWeb.FallbackController

  # GET /api/feedbacks
  # Allows managers, users, or HR to fetch relevant feedback lists
  def index(conn, params) do
    feedbacks = Feedbacks.list_feedbacks(params)
    render(conn, :index, feedbacks: feedbacks)
  end

  # POST /api/feedbacks
  # Creates a connection block containing a subject and a description
  def create(conn, %{"feedback" => feedback_params}) do
    with {:ok, %Feedback{} = feedback} <- Feedbacks.create_feedback(feedback_params) do
      conn
      |> put_status(:created)
      |> render(:show, feedback: feedback)
    end
  end
end

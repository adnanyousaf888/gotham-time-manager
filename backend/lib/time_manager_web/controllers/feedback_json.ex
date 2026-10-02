defmodule TimeManagerWeb.FeedbackJSON do
  alias TimeManager.Feedbacks.Feedback

  @doc """
  Renders a collection list of feedback messages across team networks.
  """
  def index(%{feedbacks: feedbacks}) do
    %{data: for(feedback <- feedbacks, do: data(feedback))}
  end

  @doc """
  Renders a single message object upon successful creation.
  """
  def show(%{feedback: feedback}) do
    %{data: data(feedback)}
  end

  # Private helper function to shape pure data maps for your Vue frontend
  defp data(%Feedback{} = feedback) do
    %{
      id: feedback.id,
      subject: feedback.subject,
      description: feedback.description,
      user_id: feedback.user_id,
      receiver_id: feedback.receiver_id
    }
  end
end

defmodule TimeManager.FeedbacksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Feedbacks` context.
  """

  @doc """
  Generate a feedback.
  """
  def feedback_fixture(attrs \\ %{}) do
    {:ok, feedback} =
      attrs
      |> Enum.into(%{
        description: "some description",
        subject: "some subject"
      })
      |> TimeManager.Feedbacks.create_feedback()

    feedback
  end
end

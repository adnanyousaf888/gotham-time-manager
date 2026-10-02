defmodule TimeManager.FeedbacksTest do
  use TimeManager.DataCase

  alias TimeManager.Feedbacks

  describe "feedbacks" do
    alias TimeManager.Feedbacks.Feedback

    import TimeManager.FeedbacksFixtures

    @invalid_attrs %{description: nil, subject: nil}

    test "list_feedbacks/0 returns all feedbacks" do
      feedback = feedback_fixture()
      assert Feedbacks.list_feedbacks() == [feedback]
    end

    test "get_feedback!/1 returns the feedback with given id" do
      feedback = feedback_fixture()
      assert Feedbacks.get_feedback!(feedback.id) == feedback
    end

    test "create_feedback/1 with valid data creates a feedback" do
      valid_attrs = %{description: "some description", subject: "some subject"}

      assert {:ok, %Feedback{} = feedback} = Feedbacks.create_feedback(valid_attrs)
      assert feedback.description == "some description"
      assert feedback.subject == "some subject"
    end

    test "create_feedback/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feedbacks.create_feedback(@invalid_attrs)
    end

    test "update_feedback/2 with valid data updates the feedback" do
      feedback = feedback_fixture()
      update_attrs = %{description: "some updated description", subject: "some updated subject"}

      assert {:ok, %Feedback{} = feedback} = Feedbacks.update_feedback(feedback, update_attrs)
      assert feedback.description == "some updated description"
      assert feedback.subject == "some updated subject"
    end

    test "update_feedback/2 with invalid data returns error changeset" do
      feedback = feedback_fixture()
      assert {:error, %Ecto.Changeset{}} = Feedbacks.update_feedback(feedback, @invalid_attrs)
      assert feedback == Feedbacks.get_feedback!(feedback.id)
    end

    test "delete_feedback/1 deletes the feedback" do
      feedback = feedback_fixture()
      assert {:ok, %Feedback{}} = Feedbacks.delete_feedback(feedback)
      assert_raise Ecto.NoResultsError, fn -> Feedbacks.get_feedback!(feedback.id) end
    end

    test "change_feedback/1 returns a feedback changeset" do
      feedback = feedback_fixture()
      assert %Ecto.Changeset{} = Feedbacks.change_feedback(feedback)
    end
  end
end

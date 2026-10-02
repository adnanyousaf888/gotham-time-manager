defmodule TimeManagerWeb.FeedbackControllerTest do
  use TimeManagerWeb.ConnCase

  import TimeManager.FeedbacksFixtures
  alias TimeManager.Feedbacks.Feedback

  @create_attrs %{
    description: "some description",
    subject: "some subject"
  }
  @update_attrs %{
    description: "some updated description",
    subject: "some updated subject"
  }
  @invalid_attrs %{description: nil, subject: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all feedbacks", %{conn: conn} do
      conn = get(conn, ~p"/api/feedbacks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create feedback" do
    test "renders feedback when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/feedbacks", feedback: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/feedbacks/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some description",
               "subject" => "some subject"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/feedbacks", feedback: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update feedback" do
    setup [:create_feedback]

    test "renders feedback when data is valid", %{conn: conn, feedback: %Feedback{id: id} = feedback} do
      conn = put(conn, ~p"/api/feedbacks/#{feedback}", feedback: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/feedbacks/#{id}")

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "subject" => "some updated subject"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, feedback: feedback} do
      conn = put(conn, ~p"/api/feedbacks/#{feedback}", feedback: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete feedback" do
    setup [:create_feedback]

    test "deletes chosen feedback", %{conn: conn, feedback: feedback} do
      conn = delete(conn, ~p"/api/feedbacks/#{feedback}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/feedbacks/#{feedback}")
      end
    end
  end

  defp create_feedback(_) do
    feedback = feedback_fixture()

    %{feedback: feedback}
  end
end

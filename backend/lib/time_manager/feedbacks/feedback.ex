defmodule TimeManager.Feedbacks.Feedback do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feedbacks" do
    field :subject, :string
    field :description, :string
    field :user_id, :id
    field :receiver_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(feedback, attrs) do
    feedback
    |> cast(attrs, [:subject, :description])
    |> validate_required([:subject, :description])
  end
end

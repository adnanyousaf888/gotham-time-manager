defmodule TimeManager.Repo.Migrations.CreateFeedbacks do
  use Ecto.Migration

  def change do
    create table(:feedbacks) do
      add :subject, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)
      add :receiver_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:feedbacks, [:user_id])
    create index(:feedbacks, [:receiver_id])
  end
end

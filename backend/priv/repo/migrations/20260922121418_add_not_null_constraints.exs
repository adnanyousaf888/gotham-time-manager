defmodule TimeManager.Repo.Migrations.AddNotNullConstraints do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :username, :string, null: false
      modify :email, :string, null: false
    end

    alter table(:clocks) do
      modify :time, :utc_datetime, null: false
      modify :user_id, :bigint, null: false
    end

    alter table(:workingtimes) do
      modify :start, :utc_datetime, null: false
      modify :end, :utc_datetime, null: false
      modify :user_id, :bigint, null: false
    end
  end
end
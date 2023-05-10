defmodule Marko.Repo.Migrations.CreateSessionsTable do
  use Ecto.Migration

  @table_name "sessions"
  def change do
    create table(@table_name, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")

      add :user_agent, :string

      add(:inserted_at, :utc_datetime_usec, null: false, default: fragment("CURRENT_TIMESTAMP"))
      add(:updated_at, :utc_datetime_usec, null: false, default: fragment("CURRENT_TIMESTAMP"))
    end
  end
end

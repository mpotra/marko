defmodule Marko.Repo.Migrations.CreatePageviewsTable do
  use Ecto.Migration

  @table_name "pageviews"
  @table_sessions "sessions"

  def change do
    create table(@table_name, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")

      add(
        :session_id,
        references(@table_sessions,
          on_delete: :delete_all,
          type: :binary_id
        ),
        null: false,
        type: :binary_id
      )

      add :view, :string
      add :page, :string
      add :info, :string

      add :engagement_time, :integer, null: false, default: 0

      add(:inserted_at, :utc_datetime_usec, null: false, default: fragment("CURRENT_TIMESTAMP"))
      add(:updated_at, :utc_datetime_usec, null: false, default: fragment("CURRENT_TIMESTAMP"))
    end
  end
end

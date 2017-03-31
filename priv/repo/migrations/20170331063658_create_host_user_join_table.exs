defmodule Jumubase.Repo.Migrations.CreateHostUserJoinTable do
  use Ecto.Migration

  def change do
    create table(:hosts_users, primary_key: false) do
      add :host_id, references(:hosts, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create unique_index(:hosts_users, [:host_id, :user_id])
    create index(:hosts_users, :user_id)
  end
end

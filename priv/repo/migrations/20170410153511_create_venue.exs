defmodule Jumubase.Repo.Migrations.CreateVenue do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add :name, :string
      add :host_id, references(:hosts, on_delete: :nothing)

      timestamps()
    end
    create index(:venues, [:host_id])

  end
end

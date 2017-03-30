defmodule Jumubase.Repo.Migrations.CreateContest do
  use Ecto.Migration

  def change do
    create table(:contests) do
      add :season, :integer
      add :round, :integer
      add :start_date, :date
      add :end_date, :date
      add :signup_deadline, :date
      add :certificate_date, :date
      add :timetables_public, :boolean, default: false, null: false
      add :host_id, references(:hosts, on_delete: :delete_all)

      timestamps()
    end
    create index(:contests, [:host_id])

  end
end

defmodule Jumubase.Repo.Migrations.CreateAppearance do
  use Ecto.Migration

  def change do
    create table(:appearances) do
      add :participant_role, :string
      add :points, :integer
      add :performance_id, references(:performances, on_delete: :nothing)
      add :participant_id, references(:participants, on_delete: :nothing)
      add :instrument_id, references(:instruments, on_delete: :nothing)

      timestamps()
    end
    create unique_index(:appearances, [:performance_id, :participant_id])
    create index(:appearances, [:performance_id])
    create index(:appearances, [:participant_id])
    create index(:appearances, [:instrument_id])

  end
end

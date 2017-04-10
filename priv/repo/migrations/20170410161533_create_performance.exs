defmodule Jumubase.Repo.Migrations.CreatePerformance do
  use Ecto.Migration

  def change do
    create table(:performances) do
      add :contest_category_id, references(:contest_categories, on_delete: :delete_all)
      add :edit_code, :string
      add :age_group, :string
      add :stage_time, :utc_datetime
      add :stage_venue_id, references(:venues, on_delete: :nilify_all)
      add :predecessor_id, references(:performances, on_delete: :nilify_all)
      add :results_public, :boolean, default: false, null: false

      timestamps()
    end

    create index(:performances, [:contest_category_id])
    create index(:performances, [:edit_code])
    create index(:performances, [:stage_venue_id])
    create index(:performances, [:predecessor_id])
  end
end

defmodule Jumubase.Repo.Migrations.CreateContestCategory do
  use Ecto.Migration

  def change do
    create table(:contest_categories) do
      add :contest_id, references(:contests, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
      add :min_age_group, :string
      add :max_age_group, :string
      add :min_advancing_age_group, :string
      add :max_advancing_age_group, :string

      timestamps()
    end

    create unique_index(:contest_categories, [:category_id, :contest_id])
    create index(:contest_categories, [:contest_id])
    create index(:contest_categories, [:category_id])
  end
end

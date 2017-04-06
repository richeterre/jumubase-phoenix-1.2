defmodule Jumubase.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :short_name, :string
      add :genre, :string
      add :solo, :boolean, default: false, null: false
      add :ensemble, :boolean, default: false, null: false

      timestamps()
    end

  end
end

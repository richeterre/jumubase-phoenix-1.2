defmodule Jumubase.Repo.Migrations.CreateInstrument do
  use Ecto.Migration

  def change do
    create table(:instruments) do
      add :name, :string

      timestamps()
    end

  end
end

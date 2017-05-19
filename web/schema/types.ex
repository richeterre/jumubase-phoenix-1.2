defmodule Jumubase.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Jumubase.Repo

  object :contest do
    field :id, :id
    field :host, :host, resolve: assoc(:host)
    field :start_date, :string
    field :contest_categories, list_of(:contest_category), resolve: assoc(:contest_categories)
    field :timetables_public, :boolean
  end

  object :host do
    field :id, :id
    field :name, :string
    field :city, :string
    field :country_code, :string
  end

  object :contest_category do
    field :id, :id
    # TODO: Resolve `name` by getting associated category's name
  end

  object :performance do
    field :id, :id
    field :contest_id, :id
    field :contest_category, :contest_category, resolve: assoc(:contest_category)
    field :edit_code, :string
    field :results_public, :boolean
  end
end

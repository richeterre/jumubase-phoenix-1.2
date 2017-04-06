defmodule Jumubase.Category do
  use Jumubase.Web, :model

  schema "categories" do
    field :name, :string
    field :short_name, :string
    field :genre, :string
    field :solo, :boolean, default: false
    field :ensemble, :boolean, default: false

    timestamps()
  end

  @required_params [:name, :short_name, :genre, :solo, :ensemble]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end

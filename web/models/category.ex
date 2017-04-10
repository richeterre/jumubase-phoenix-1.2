defmodule Jumubase.Category do
  use Jumubase.Web, :model
  import Jumubase.Gettext

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
    |> validate_inclusion(:genre, JumuParams.genres())
    |> validate_type
  end

  def validate_type(changeset) do
    if !get_field(changeset, :solo) && !get_field(changeset, :ensemble) do
      error = dgettext("errors", "At least one category type must be checked.")
      changeset
      |> add_error(:base, error)
    else
      changeset
    end
  end

  def list_order(query) do
    from c in query,
    order_by: [asc: c.genre, desc: c.solo, asc: c.name]
  end
end

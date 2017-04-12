defmodule Jumubase.Instrument do
  use Jumubase.Web, :model

  schema "instruments" do
    field :name, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end

defmodule Jumubase.Host do
  use Jumubase.Web, :model

  schema "hosts" do
    field :name, :string
    field :city, :string
    field :country_code, :string
    field :time_zone, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :city, :country_code, :time_zone])
    |> validate_required([:name, :city, :country_code, :time_zone])
  end
end

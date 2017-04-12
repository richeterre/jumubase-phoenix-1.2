defmodule Jumubase.Participant do
  use Jumubase.Web, :model

  schema "participants" do
    field :given_name, :string
    field :family_name, :string
    field :birthdate, Ecto.Date
    field :phone, :string
    field :email, :string

    timestamps()
  end

  @required_params [:given_name, :family_name, :birthdate, :phone, :email]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end

defmodule Jumubase.User do
  use Jumubase.Web, :model

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password_hash])
    |> validate_required([:email, :password_hash])
  end
end

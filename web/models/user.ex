defmodule Jumubase.User do
  use Jumubase.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :string
    many_to_many :hosts, Jumubase.Host, join_through: "hosts_users", on_replace: :delete

    timestamps()
  end

  @required_params [:first_name, :last_name, :email, :role]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_inclusion(:role, JumuParams.roles())
    |> unique_constraint(:email)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6)
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash,
          Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end

defmodule Jumubase.Host do
  use Jumubase.Web, :model

  schema "hosts" do
    field :name, :string
    field :city, :string
    field :country_code, :string
    field :time_zone, :string
    has_many :contests, Jumubase.Contest, on_delete: :delete_all
    many_to_many :users, Jumubase.User, join_through: "hosts_users", on_replace: :delete

    timestamps()
  end

  @required_params [:name, :city, :country_code, :time_zone]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end

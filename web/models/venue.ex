defmodule Jumubase.Venue do
  use Jumubase.Web, :model

  schema "venues" do
    field :name, :string
    belongs_to :host, Jumubase.Host

    timestamps()
  end

  @required_params [:name, :host_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end

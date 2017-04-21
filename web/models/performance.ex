defmodule Jumubase.Performance do
  use Jumubase.Web, :model

  schema "performances" do
    field :edit_code, :string
    field :age_group, :string
    field :stage_time, Timex.Ecto.DateTime
    field :results_public, :boolean, default: false
    belongs_to :contest_category, Jumubase.ContestCategory
    belongs_to :stage_venue, Jumubase.Venue
    belongs_to :predecessor, Jumubase.Performance
    has_many :appearances, Jumubase.Appearance

    timestamps()
  end

  @required_params [:contest_category_id, :edit_code, :results_public]
  @optional_params [:age_group, :stage_time, :stage_venue_id, :predecessor_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_inclusion(:age_group, JumuParams.age_groups())
  end
end

defmodule Jumubase.Appearance do
  use Jumubase.Web, :model

  schema "appearances" do
    field :participant_role, :string
    field :points, :integer
    belongs_to :performance, Jumubase.Performance
    belongs_to :participant, Jumubase.Participant
    belongs_to :instrument, Jumubase.Instrument

    timestamps()
  end

  @required_params [:performance_id, :participant_id, :participant_role, :instrument_id]
  @optional_params [:points]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_inclusion(:participant_role, JumuParams.participant_roles())
    |> validate_inclusion(:points, JumuParams.points())
  end
end

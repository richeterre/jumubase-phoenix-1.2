defmodule Jumubase.Contest do
  use Jumubase.Web, :model

  schema "contests" do
    field :season, :integer
    field :round, :integer
    field :start_date, Timex.Ecto.Date
    field :end_date, Timex.Ecto.Date
    field :signup_deadline, Timex.Ecto.Date
    field :certificate_date, Timex.Ecto.Date
    field :timetables_public, :boolean, default: false
    belongs_to :host, Jumubase.Host
    has_many :contest_categories, Jumubase.ContestCategory, on_delete: :delete_all
    has_many :performances, through: [:contest_categories, :performances]
    has_many :venues, through: [:host, :venues]

    timestamps()
  end

  @required_params [:season, :round, :host_id, :start_date, :end_date,
    :signup_deadline, :timetables_public]
  @optional_params [:certificate_date]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> validate_number(:season, greater_than: 0)
    |> validate_inclusion(:round, JumuParams.rounds)
    # TODO: Validate dates
  end
end

defmodule Jumubase.ContestCategory do
  use Jumubase.Web, :model
  alias Jumubase.{Category, Contest}

  schema "contest_categories" do
    field :min_age_group, :string
    field :max_age_group, :string
    field :min_advancing_age_group, :string
    field :max_advancing_age_group, :string
    belongs_to :contest, Contest
    belongs_to :category, Category

    timestamps()
  end

  @required_params [:contest_id, :category_id, :min_age_group,
    :max_age_group, :min_advancing_age_group, :max_advancing_age_group]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_inclusion(:min_age_group, JumuParams.age_groups())
    |> validate_inclusion(:max_age_group, JumuParams.age_groups())
    |> validate_inclusion(:min_advancing_age_group, JumuParams.age_groups())
    |> validate_inclusion(:max_advancing_age_group, JumuParams.age_groups())
  end

  def list_order(query) do
    from cc in query,
    join: c in subquery(Category |> Category.list_order),
    on: cc.category_id == c.id
  end
end

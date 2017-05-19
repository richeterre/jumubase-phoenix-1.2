defmodule Jumubase.PerformanceResolver do
  import Ecto.Query
  alias Jumubase.{ContestCategory, Performance}
  alias Jumubase.Repo

  def all(%{contest_id: contest_id} = args, _info) do
    query = from(p in Performance,
      join: cc in ContestCategory,
      on: p.contest_category_id == cc.id,
      where: cc.contest_id == ^contest_id
    )

    query = query |> filter(args)

    {:ok, Repo.all(query)}
  end

  defp filter(query, args) do
    if cc_id = Map.get(args, :contest_category_id) do
      query = query |> where(contest_category_id: ^cc_id)
    end

    rp = Map.get(args, :results_public)
    if !is_nil(rp) do
      query = query |> where(results_public: ^rp)
    end

    query
  end
end

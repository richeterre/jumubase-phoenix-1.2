defmodule Jumubase.ContestResolver do
  import Ecto.Query
  alias Jumubase.Contest
  alias Jumubase.Repo

  def all(args, _info) do
    query = case args do
      nil ->
        Contest
      args ->
        Contest |> filter(args)
    end

    {:ok, Repo.all(query)}
  end

  defp filter(query, args) do
    ttp = Map.get(args, :timetables_public)
    if !is_nil(ttp) do
      query = query |> where(timetables_public: ^ttp)
    end

    if Map.get(args, :current_only) do
      date = ~D[2017-01-01]
      query = query |> where([c], c.start_date > ^date)
    end

    query
  end
end

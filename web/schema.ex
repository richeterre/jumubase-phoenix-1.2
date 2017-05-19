defmodule Jumubase.Schema do
  use Absinthe.Schema
  import_types Jumubase.Schema.Types

  query do
    field :contests, list_of(:contest) do
      arg :current_only, :boolean
      arg :timetables_public, :boolean
      resolve &Jumubase.ContestResolver.all/2
    end

    field :performances, list_of(:performance) do
      arg :contest_id, non_null(:id)
      arg :contest_category_id, :id
      arg :results_public, :boolean
      resolve &Jumubase.PerformanceResolver.all/2
    end
  end
end

defmodule Jumubase.Internal.ContestCategoryView do
  use Jumubase.Web, :view

  def age_group_range(contest_category) do
    "#{contest_category.min_age_group}–#{contest_category.max_age_group}"
  end
end

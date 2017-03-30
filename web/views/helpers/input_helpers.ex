defmodule Jumubase.InputHelpers do
  use Phoenix.HTML
  import Jumubase.Gettext

  def custom_date_select(form, field, opts \\ []) do
    date_select form, field, opts ++ [
      year: [prompt: gettext("Year")],
      month: [prompt: gettext("Month")],
      day: [prompt: gettext("Day")],
    ]
  end
end

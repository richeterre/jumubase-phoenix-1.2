defmodule Jumubase.Internal.PerformanceView do
  use Jumubase.Web, :view
  import Jumubase.Internal.ParticipantView, only: [full_name: 1]
  alias Jumubase.{Appearance, Performance}

  @doc """
  Returns the name of the performance's associated category.
  """
  def category_name(%Performance{} = performance) do
    performance.contest_category.category.name
  end

  @doc """
  Returns a displayable string for the appearance's participant.
  """
  def participant_info(%Appearance{} = appearance) do
    "#{full_name(appearance.participant)}, #{appearance.instrument.name}"
  end
end

defmodule Jumubase.Internal.ParticipantView do
  use Jumubase.Web, :view
  alias Jumubase.Participant

  @doc """
  Returns the participant's full name.
  """
  def full_name(%Participant{} = participant) do
    "#{participant.given_name} #{participant.family_name}"
  end
end

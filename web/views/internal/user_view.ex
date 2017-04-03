defmodule Jumubase.Internal.UserView do
  use Jumubase.Web, :view

  @doc """
  Returns the given user's full name.
  """
  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  @doc """
  Returns all roles in a format suitable for forms.
  """
  def form_roles do
    Enum.map(JumuParams.roles(), &({role_name(&1), &1}))
  end

  defp role_name(role) do
    case role do
      "admin" -> gettext("Admin")
      "inspector" -> gettext("Inspector")
      "lw-organizer" -> gettext("LW Organizer")
      "rw-organizer" -> gettext("RW Organizer")
    end
  end
end

defmodule Jumubase.Internal.UserView do
  use Jumubase.Web, :view

  def roles do
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

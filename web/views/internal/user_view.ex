defmodule Jumubase.Internal.UserView do
  use Jumubase.Web, :view

  @doc """
  Returns the given user's full name.
  """
  def full_name(user) do
    "#{user.first_name} #{user.last_name}"
  end

  @doc """
  Returns the user's associated hosts as Emoji flags.
  """
  def host_flags(user) do
    user.hosts
    |> Enum.map(fn(host) -> emoji_flag(host.country_code) end)
  end

  @doc """
  Returns the names of the user's associated hosts.
  """
  def host_names(user) do
    user.hosts
    |> Enum.map(&(&1.name))
    |> Enum.join(", ")
  end

  @doc """
  Returns all roles in a format suitable for forms.
  """
  def form_roles do
    Enum.map(JumuParams.roles(), &({role_name(&1), &1}))
  end

  @doc """
  Returns a label text describing the user's special role.
  """
  def role_label(user) do
    if user.role !== "rw-organizer", do: role_name(user.role)
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

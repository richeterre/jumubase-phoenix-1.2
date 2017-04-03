defmodule Jumubase.AuthHelpers do
  use Phoenix.HTML

  def signed_in?(conn), do: Guardian.Plug.authenticated?(conn)

  @doc """
  Creates a label tag describing the user's role.
  """
  def role_label_tag(label_text, role) do
    case label_text do
      nil -> nil
      text ->
        content_tag :span, text,
          class: "label label-#{label_class(role)}"
    end
  end

  defp label_class(role) do
    case role do
      "admin" -> "danger"
      "inspector" -> "info"
      "lw-organizer" -> "warning"
      _ -> "default"
    end
  end
end

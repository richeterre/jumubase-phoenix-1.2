defmodule Jumubase.LabelHelpers do
  use Phoenix.HTML

  @doc """
  Creates a label for a category type.
  """
  def category_type_label_tag(text) do
    content_tag :span, text, class: "label label-info"
  end

  @doc """
  Creates a label describing the user's role.
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

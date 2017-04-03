defmodule Jumubase.IconHelpers do
  use Phoenix.HTML

  @doc """
  Generates a Glyphicon.
  """
  def icon_tag(icon) do
    content_tag(:span, nil, class: "glyphicon glyphicon-#{icon}")
  end

  @doc """
  Generates a link with a prepended icon.
  """
  def icon_link(icon, title, path, opts \\ []) do
    link [to: path] ++ opts do
      if title, do: [icon_tag(icon), " ", title], else: icon_tag(icon)
    end
  end
end

defmodule Jumubase.LinkHelpers do
  use Phoenix.HTML

  def icon_link(icon, title, path) do
    link to: path do
      icon = content_tag(:span, nil, class: "glyphicon glyphicon-#{icon}")
      [icon, " ", title]
    end
  end
end

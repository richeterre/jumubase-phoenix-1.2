defmodule Jumubase.BreadcrumbHelpers do
  use Phoenix.HTML
  import Jumubase.IconHelpers

  @doc """
  Renders a single breadcrumb based on the available params.
  """
  def render_breadcrumb(url, icon, name) do
    case {url, icon, name} do
      {nil, icon, nil} ->
        icon_tag(icon)
      {nil, nil, name} ->
        name
      {url, icon, nil} ->
        icon_link(icon, nil, url)
      {url, nil, name} ->
        link name, to: url
    end
  end
end

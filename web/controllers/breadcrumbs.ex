defmodule Jumubase.Breadcrumbs do
  def add_breadcrumb(conn, opts) do
    breadcrumb = [name: opts[:name], icon: opts[:icon], url: opts[:url]]
    breadcrumbs = Map.get(conn.assigns, :breadcrumbs, []) ++ [breadcrumb]
    conn |> Plug.Conn.assign(:breadcrumbs, breadcrumbs)
  end
end

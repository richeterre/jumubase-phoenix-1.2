defmodule Jumubase.LayoutView do
  use Jumubase.Web, :view
  import Jumubase.BreadcrumbHelpers

  @doc """
  Tells whether the given breadcrumb is active.
  """
  def breadcrumb_active(conn, breadcrumb) do
    breadcrumb[:url] === conn.request_path
  end
end

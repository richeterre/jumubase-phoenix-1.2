defmodule Jumubase.Internal.PageController do
  use Jumubase.Web, :controller
  alias Jumubase.Endpoint

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)

  def home(conn, _params) do
    render conn, "home.html"
  end
end

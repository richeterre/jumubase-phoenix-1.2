defmodule Jumubase.Internal.PageController do
  use Jumubase.Web, :controller
  alias Jumubase.{Contest, Endpoint}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)

  def home(conn, _params) do
    user = conn.assigns.current_user
    contest_query = from(c in Contest, preload: :host)
    |> Permit.accessible_by(user)

    conn
    |> assign(:contests, Repo.all(contest_query))
    |> render("home.html")
  end
end

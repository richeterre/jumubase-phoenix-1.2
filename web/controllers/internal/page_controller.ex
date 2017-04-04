defmodule Jumubase.Internal.PageController do
  use Jumubase.Web, :controller
  alias Jumubase.{Contest, Endpoint}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)

  def action(conn, _) do
    # Pass current user as param to all actions
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def home(conn, _params, user) do
    contest_query = from(c in Contest, preload: :host)
    |> Permit.accessible_by(user)
    conn
    |> assign(:contests, Repo.all(contest_query))
    |> render("home.html")
  end
end

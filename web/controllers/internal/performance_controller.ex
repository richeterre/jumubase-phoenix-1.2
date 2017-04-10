defmodule Jumubase.Internal.PerformanceController do
  use Jumubase.Web, :controller
  import Jumubase.Auth, only: [current_user: 1]
  import Jumubase.Internal.ContestView, only: [name_with_flag: 1]
  alias Jumubase.Auth
  alias Jumubase.Endpoint
  alias Jumubase.{Contest}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Contests"), url: internal_contest_path(Endpoint, :index)

  plug :authorize_action, resource: Performance

  def index(conn, %{"contest_id" => contest_id}) do
    contest = Repo.get!(Contest, contest_id)
    |> Repo.preload([:host, performances: [contest_category: :category]])

    if Permit.authorized?(current_user(conn), :list_performances, contest) do
      conn
      |> assign(:performances, contest.performances)
      |> add_breadcrumb(name: name_with_flag(contest),
        url: internal_contest_path(Endpoint, :show, contest))
      |> add_breadcrumb(name: gettext("Performances"),
        url: internal_contest_performance_path(Endpoint, :index, contest))
      |> render("index.html")
    else
      conn |> Auth.unauthorized
    end
  end
end

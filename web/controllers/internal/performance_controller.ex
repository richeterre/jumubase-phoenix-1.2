defmodule Jumubase.Internal.PerformanceController do
  use Jumubase.Web, :controller
  import Jumubase.Auth, only: [current_user: 1]
  import Jumubase.Internal.ContestView, only: [name_with_flag: 1]
  import Jumubase.Internal.PerformanceView, only: [category_name: 1]
  alias Jumubase.Auth
  alias Jumubase.Endpoint
  alias Jumubase.{Contest, Performance}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Contests"), url: internal_contest_path(Endpoint, :index)

  plug :authorize_action, resource: Performance

  def index(conn, %{"contest_id" => contest_id}) do
    contest = Repo.get!(Contest, contest_id)
    |> Repo.preload([:host, performances: [contest_category: :category]])

    if Permit.authorized?(current_user(conn), :list_performances, contest) do
      conn
      |> assign(:contest, contest)
      |> assign(:performances, contest.performances)
      |> add_contest_breadcrumb(contest)
      |> add_performances_breadcrumb(contest)
      |> render("index.html")
    else
      conn |> Auth.unauthorized
    end
  end

  def show(conn, %{"contest_id" => contest_id, "id" => id}) do
    performance = Repo.get!(Performance, id)
    |> Repo.preload([
        appearances: [:instrument, :participant],
        contest_category: [:category, contest: :host]
      ])
    contest = performance.contest_category.contest

    cond do
      # Handle contest/performance mismatch
      String.to_integer(contest_id) != contest.id ->
        conn
        |> put_status(:not_found)
        |> render(Jumubase.ErrorView, "404.html")
      # Handle insufficient user permissions
      !Permit.authorized?(current_user(conn), :show, performance) ->
        conn |> Auth.unauthorized
      true ->
        conn
        |> assign(:performance, performance)
        |> add_contest_breadcrumb(contest)
        |> add_performances_breadcrumb(contest)
        |> add_breadcrumb(name: category_name(performance),
          url: internal_contest_performance_path(conn, :show, contest, performance))
        |> render("show.html")
    end
  end

  defp add_contest_breadcrumb(conn, %Contest{} = contest) do
    add_breadcrumb(conn, name: name_with_flag(contest),
      url: internal_contest_path(Endpoint, :show, contest))
  end

  defp add_performances_breadcrumb(conn, %Contest{} = contest) do
    add_breadcrumb(conn, name: gettext("Performances"),
      url: internal_contest_performance_path(conn, :index, contest))
  end
end

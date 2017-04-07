defmodule Jumubase.Internal.ContestController do
  use Jumubase.Web, :controller
  import Jumubase.Internal.ContestView, only: [name: 1]

  alias Jumubase.Endpoint
  alias Jumubase.Contest
  alias Jumubase.Host

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Contests"), url: internal_contest_path(Endpoint, :index)

  plug :authorize_action, resource: Contest

  def index(conn, _params) do
    user = conn.assigns.current_user
    query = from(c in Contest, order_by: [desc: c.start_date], preload: :host)
    |> Permit.accessible_by(user)

    conn
    |> assign(:contests, Repo.all(query))
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    contest = Repo.get!(Contest, id) |> Repo.preload(:host)
    conn
    |> authorize_action(resource: contest)
    |> assign(:contest, contest)
    |> add_breadcrumb(name: name(contest), url: internal_contest_path(Endpoint, :show, contest))
    |> render("show.html")
  end

  def new(conn, _params) do
    conn
    |> prepare_for_form(Contest.changeset(%Contest{}))
    |> add_breadcrumb(icon: "plus", url: internal_contest_path(Endpoint, :new))
    |> render("new.html")
  end

  def create(conn, %{"contest" => contest_params}) do
    changeset = Contest.changeset(%Contest{}, contest_params)

    case Repo.insert(changeset) do
      {:ok, _contest} ->
        conn
        |> put_flash(:success, gettext("The contest was created."))
        |> redirect(to: internal_contest_path(conn, :index))
      {:error, changeset} ->
        conn
        |> prepare_for_form(changeset)
        |> render("new.html")
    end
  end

  defp prepare_for_form(conn, changeset) do
    conn
    |> assign(:changeset, changeset)
    |> assign(:rounds, JumuParams.rounds)
    |> assign_hosts
  end

  defp assign_hosts(conn) do
    query = from(h in Host, select: {h.name, h.id})
    assign(conn, :hosts, Repo.all(query))
  end
end

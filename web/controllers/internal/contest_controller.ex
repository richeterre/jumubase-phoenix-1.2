defmodule Jumubase.Internal.ContestController do
  use Jumubase.Web, :controller
  use Jumubase.Internal.Controller
  import Jumubase.Internal.ContestView, only: [name: 1]

  alias Jumubase.Endpoint
  alias Jumubase.Contest
  alias Jumubase.Host

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Contests"), url: internal_contest_path(Endpoint, :index)

  def index(conn, _params, user) do
    case Permit.authorize(Contest, :index, user) do
      :ok ->
        query = from(c in Contest, order_by: [desc: c.start_date], preload: :host)
        |> Permit.accessible_by(user)

        conn
        |> assign(:contests, Repo.all(query))
        |> render("index.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def show(conn, %{"id" => id}, user) do
    contest = Repo.get!(Contest, id) |> Repo.preload(:host)
    case Permit.authorize(contest, :show, user) do
      :ok ->
        conn
        |> assign(:contest, contest)
        |> add_breadcrumb(name: name(contest), url: internal_contest_path(Endpoint, :show, contest))
        |> render("show.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def new(conn, _params, user) do
    case Permit.authorize(Contest, :new, user) do
      :ok ->
        conn
        |> prepare_for_form(Contest.changeset(%Contest{}))
        |> add_breadcrumb(icon: "plus", url: internal_contest_path(Endpoint, :new))
        |> render("new.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def create(conn, %{"contest" => contest_params}, user) do
    changeset = Contest.changeset(%Contest{}, contest_params)
    with :ok <- Permit.authorize(Contest, :create, user),
      {:ok, contest} <- Repo.insert(changeset)
    do
      conn
      |> put_flash(:success, gettext("The contest was created."))
      |> redirect(to: internal_contest_path(conn, :index))
    else
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
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

defmodule Jumubase.Internal.ContestController do
  use Jumubase.Web, :controller

  alias Jumubase.Endpoint
  alias Jumubase.Contest
  alias Jumubase.Host

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Contests"), url: internal_contest_path(Endpoint, :index)

  def index(conn, _params) do
    contests = Repo.all from c in Contest, preload: [:host]

    conn
    |> assign(:contests, contests)
    |> render("index.html")
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

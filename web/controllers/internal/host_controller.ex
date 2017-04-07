defmodule Jumubase.Internal.HostController do
  use Jumubase.Web, :controller
  alias Jumubase.{Endpoint, Host}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Hosts"), url: internal_host_path(Endpoint, :index)

  plug :authorize_action, resource: Host

  def index(conn, _params) do
    conn
    |> assign(:hosts, Repo.all(from h in Host, order_by: h.name))
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Host.changeset(%Host{}))
    |> add_breadcrumb(icon: "plus", url: internal_host_path(Endpoint, :new))
    |> render("new.html")
  end

  def create(conn, %{"host" => host_params}) do
    changeset = Host.changeset(%Host{}, host_params)

    case Repo.insert(changeset) do
      {:ok, host} ->
        conn
        |> put_flash(:success,
          gettext("The host \"%{name}\" was created.", name: host.name))
        |> redirect(to: internal_host_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end

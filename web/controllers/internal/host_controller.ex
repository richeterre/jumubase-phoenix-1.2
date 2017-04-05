defmodule Jumubase.Internal.HostController do
  use Jumubase.Web, :controller
  use Jumubase.Internal.Controller
  alias Jumubase.{Endpoint, Host}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Hosts"), url: internal_host_path(Endpoint, :index)

  def index(conn, _params, user) do
    case Permit.authorize(Host, :index, user) do
      :ok ->
        conn
        |> assign(:hosts, Repo.all(from h in Host, order_by: h.name))
        |> render("index.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def new(conn, _params, user) do
    case Permit.authorize(Host, :new, user) do
      :ok ->
        conn
        |> assign(:changeset, Host.changeset(%Host{}))
        |> add_breadcrumb(icon: "plus", url: internal_host_path(Endpoint, :new))
        |> render("new.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def create(conn, %{"host" => host_params}, user) do
    changeset = Host.changeset(%Host{}, host_params)
    with :ok <- Permit.authorize(Host, :create, user),
      {:ok, host} <- Repo.insert(changeset)
    do
      conn
        |> put_flash(:success,
          gettext("The host \"%{name}\" was created.", name: host.name))
        |> redirect(to: internal_host_path(conn, :index))
    else
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end

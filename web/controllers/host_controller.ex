defmodule Jumubase.HostController do
  use Jumubase.Web, :controller
  alias Jumubase.Host

  def index(conn, _params) do
    conn
    |> assign(:hosts, Repo.all(Host))
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Host.changeset(%Host{}))
    |> render("new.html")
  end

  def create(conn, %{"host" => host_params}) do
    changeset = Host.changeset(%Host{}, host_params)
    case Repo.insert(changeset) do
      {:ok, host} ->
        conn
        |> put_flash(:success,
          gettext("The host \"%{name}\" was created.", name: host.name))
        |> redirect(to: host_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end
end

defmodule Jumubase.Internal.UserController do
  use Jumubase.Web, :controller
  import Jumubase.Internal.UserView, only: [full_name: 1]
  alias Jumubase.Endpoint

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Users"), url: internal_user_path(Endpoint, :index)

  alias Jumubase.User
  alias Jumubase.Host

  def index(conn, _params) do
    conn
    |> assign(:users, Repo.all(User))
    |> render("index.html")
  end

  def new(conn, _params) do
    user = %User{hosts: []}

    conn
    |> prepare_for_form(User.changeset(user))
    |> add_breadcrumb(icon: "plus", url: internal_user_path(Endpoint, :new))
    |> render("new.html")
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{hosts: []}
    |> User.registration_changeset(user_params)
    |> put_hosts_assoc(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:success,
          gettext("The user %{name} was created.", name: full_name(user)))
        |> redirect(to: internal_user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> prepare_for_form(changeset)
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    |> Repo.preload(:hosts)

    conn
    |> assign(:user, user)
    |> prepare_for_form(User.changeset(user))
    |> add_breadcrumb(name: full_name(user))
    |> add_breadcrumb(icon: "pencil", url: internal_user_path(Endpoint, :edit, user))
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    |> Repo.preload(:hosts)

    changeset = User.changeset(user, user_params)
    |> put_hosts_assoc(user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info,
          gettext("The user %{name} was updated.", name: full_name(user)))
        |> redirect(to: internal_user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:user, user)
        |> prepare_for_form(changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete!(user)

    conn
    |> put_flash(:info,
      gettext("The user %{name} was deleted.", name: full_name(user)))
    |> redirect(to: internal_user_path(conn, :index))
  end

  defp prepare_for_form(conn, changeset) do
    host_query = from(h in Host, select: {h.name, h.id})
    conn
    |> assign(:changeset, changeset)
    |> assign(:host_ids, Repo.all(host_query))
  end

  defp put_hosts_assoc(changeset, user_params) do
    host_ids = user_params["host_ids"] || []
    hosts = Repo.all from h in Host, where: h.id in ^host_ids

    changeset |> Ecto.Changeset.put_assoc(:hosts, hosts)
  end
end

defmodule Jumubase.Internal.UserController do
  use Jumubase.Web, :controller
  import Jumubase.Auth, only: [current_user: 1]
  import Jumubase.Internal.UserView, only: [full_name: 1]
  alias Jumubase.Auth
  alias Jumubase.{Endpoint, Host, User}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Users"), url: internal_user_path(Endpoint, :index)

  plug :authorize_action, resource: User

  def index(conn, _params) do
    users = Repo.all(from u in User, order_by: u.first_name)
    |> Repo.preload(hosts: from(h in Host, order_by: h.name))

    conn
    |> assign(:users, users)
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
    |> authorize_action(resource: user)
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

    with :ok <- Permit.authorize(user, :update, current_user(conn)),
      {:ok, user} <- Repo.update(changeset)
    do
      conn
      |> put_flash(:success,
        gettext("The user %{name} was updated.", name: full_name(user)))
      |> redirect(to: internal_user_path(conn, :index))
    else
      {:error, :unauthorized} ->
        conn |> Auth.unauthorized
      {:error, changeset} ->
        conn
        |> assign(:user, user)
        |> prepare_for_form(changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    with :ok <- Permit.authorize(user, :delete, current_user(conn)),
      {:ok, _user} <- Repo.delete(user)
    do
      conn
      |> put_flash(:success,
        gettext("The user %{name} was deleted.", name: full_name(user)))
      |> redirect(to: internal_user_path(conn, :index))
    else
      {:error, :unauthorized} ->
        conn |> Auth.unauthorized
    end
  end

  defp prepare_for_form(conn, changeset) do
    host_query = from(h in Host, select: {h.name, h.id}, order_by: h.name)
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

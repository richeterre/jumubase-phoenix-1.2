defmodule Jumubase.Internal.UserController do
  use Jumubase.Web, :controller
  use Jumubase.Internal.Controller
  import Jumubase.Internal.UserView, only: [full_name: 1]
  alias Jumubase.{Endpoint, Host, User}

  plug :add_breadcrumb, icon: "home", url: internal_page_path(Endpoint, :home)
  plug :add_breadcrumb, name: gettext("Users"), url: internal_user_path(Endpoint, :index)

  def index(conn, _params, current_user) do
    case Permit.authorize(User, :index, current_user) do
      :ok ->
        conn
        |> assign(:users, Repo.all(User))
        |> render("index.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def new(conn, _params, current_user) do
    case Permit.authorize(User, :new, current_user) do
      :ok ->
        user = %User{hosts: []}
        conn
        |> prepare_for_form(User.changeset(user))
        |> add_breadcrumb(icon: "plus", url: internal_user_path(Endpoint, :new))
        |> render("new.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def create(conn, %{"user" => user_params}, current_user) do
    changeset = %User{hosts: []}
    |> User.registration_changeset(user_params)
    |> put_hosts_assoc(user_params)

    with :ok <- Permit.authorize(User, :create, current_user),
      {:ok, user} <- Repo.insert(changeset)
    do
      conn
      |> put_flash(:success,
        gettext("The user %{name} was created.", name: full_name(user)))
      |> redirect(to: internal_user_path(conn, :index))
    else
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
      {:error, changeset} ->
        conn
        |> prepare_for_form(changeset)
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    case Permit.authorize(User, :edit, current_user) do
      :ok ->
        user = Repo.get!(User, id)
        |> Repo.preload(:hosts)
        conn
        |> assign(:user, user)
        |> prepare_for_form(User.changeset(user))
        |> add_breadcrumb(name: full_name(user))
        |> add_breadcrumb(icon: "pencil", url: internal_user_path(Endpoint, :edit, user))
        |> render("edit.html")
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, current_user) do
    user = Repo.get!(User, id)
    |> Repo.preload(:hosts)

    changeset = User.changeset(user, user_params)
    |> put_hosts_assoc(user_params)

    with :ok <- Permit.authorize(User, :update, current_user),
      {:ok, user} <- Repo.update(changeset)
    do
      conn
      |> put_flash(:success,
        gettext("The user %{name} was updated.", name: full_name(user)))
      |> redirect(to: internal_user_path(conn, :index))
    else
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
      {:error, changeset} ->
        conn
        |> assign(:user, user)
        |> prepare_for_form(changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    case Permit.authorize(User, :delete, current_user) do
      :ok ->
        user = Repo.get!(User, id)
        |> Repo.delete!
        conn
        |> put_flash(:success,
          gettext("The user %{name} was deleted.", name: full_name(user)))
        |> redirect(to: internal_user_path(conn, :index))
      {:error, :unauthorized} ->
        conn |> Permit.unauthorized()
    end
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

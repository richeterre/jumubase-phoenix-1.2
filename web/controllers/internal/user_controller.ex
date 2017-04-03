defmodule Jumubase.Internal.UserController do
  use Jumubase.Web, :controller
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
          gettext("The user \"%{email}\" was created.", email: user.email))
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
          gettext("The user \"%{email}\" was updated.", email: user.email))
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
      gettext("The user \"%{email}\" was deleted.", email: user.email))
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

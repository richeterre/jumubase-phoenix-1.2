defmodule Jumubase.Internal.UserController do
  use Jumubase.Web, :controller
  alias Jumubase.User

  def index(conn, _params) do
    conn
    |> assign(:users, Repo.all(User))
    |> render("index.html")
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, User.changeset(%User{}))
    |> render("new.html")
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:success,
          gettext("The user \"%{email}\" was created.", email: user.email))
        |> redirect(to: internal_user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    conn
    |> assign(:changeset, User.changeset(user))
    |> assign(:user, user)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info,
          gettext("The user \"%{email}\" was updated.", email: user.email))
        |> redirect(to: internal_user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
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
end

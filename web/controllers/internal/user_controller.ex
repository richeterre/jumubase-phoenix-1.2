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
    changeset = User.changeset(%User{}, user_params)
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
end

defmodule Jumubase.Auth do
  use Jumubase.Web, :controller

  alias Jumubase.User
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def current_user(conn), do: conn.assigns.current_user

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user, :access)
  end

  def login_by_email_and_pw(conn, email, pw, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: email)

    cond do
      user && checkpw(pw, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, gettext("You are now signed out. See you soon!"))
    |> redirect(to: "/")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:warning,
      gettext("Please sign in to access this page."))
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end

  def unauthorized(conn) do
    conn
    |> put_flash(:warning,
      gettext("Please sign in with sufficient permissions to access this page."))
    |> redirect(to: page_path(conn, :home))
    |> halt()
  end
end

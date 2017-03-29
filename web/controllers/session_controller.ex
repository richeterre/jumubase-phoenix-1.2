defmodule Jumubase.SessionController do
  use Jumubase.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pw}}) do
    case Jumubase.Auth.login_by_email_and_pw(conn, email, pw, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, gettext("You are now signed in."))
        |> redirect(to: internal_page_path(conn, :home))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, gettext("You could not be signed in."))
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: "/")
  end
end

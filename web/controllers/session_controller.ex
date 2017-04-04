defmodule Jumubase.SessionController do
  use Jumubase.Web, :controller
  alias Jumubase.Auth

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pw}}) do
    case Auth.login_by_email_and_pw(conn, email, pw, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, gettext("You are now signed in."))
        |> redirect(to: internal_page_path(conn, :home))
      {:error, reason, conn} ->
        conn
        |> put_flash(:error, error_message(reason))
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    Auth.logout(conn)
  end

  defp error_message(reason) do
    case reason do
      :unauthorized ->
        gettext("You entered the wrong password.")
      :not_found ->
        gettext("We couldn't find a user with this email.")
      _ ->
        gettext("You could not be signed in.")
    end
  end
end

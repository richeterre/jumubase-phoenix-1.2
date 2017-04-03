defmodule Jumubase.Permit do
  use Jumubase.Web, :controller
  alias Jumubase.{Host, User}

  def authorize(_, _, %User{role: "admin"}), do: :ok
  def authorize(Host, _, %User{}), do: {:error, :unauthorized}

  def unauthorized(conn) do
    conn
    |> put_flash(:warning,
      gettext("Please sign in with sufficient permissions to access this page."))
    |> redirect(to: page_path(conn, :home))
    |> halt()
  end
end

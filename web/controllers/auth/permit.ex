defmodule Jumubase.Permit do
  use Jumubase.Web, :controller
  alias Jumubase.{Contest, Host, User}

  def authorize(_, _, %User{role: "admin"}), do: :ok
  def authorize(Contest, _, %User{}), do: {:error, :unauthorized}
  def authorize(Host, _, %User{}), do: {:error, :unauthorized}
  def authorize(User, _, %User{}), do: {:error, :unauthorized}

  def accessible_by(query, %User{role: "admin"}), do: query
  def accessible_by(query, %User{} = user) do
    user = user |> Repo.preload(:hosts)
    host_ids = user.hosts |> Enum.map(&(&1.id))
    from c in query, where: c.host_id in ^host_ids
  end

  def unauthorized(conn) do
    conn
    |> put_flash(:warning,
      gettext("Please sign in with sufficient permissions to access this page."))
    |> redirect(to: page_path(conn, :home))
    |> halt()
  end
end

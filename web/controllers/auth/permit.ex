defmodule Jumubase.Permit do
  use Jumubase.Web, :controller
  alias Jumubase.{Category, Contest, Host, User}

  # Action-based rules
  def authorize(_, _, %User{role: "admin"}), do: :ok
  def authorize(Category, _, %User{}), do: {:error, :unauthorized}
  def authorize(Contest, :index, %User{}), do: :ok
  def authorize(Contest, _, %User{}), do: {:error, :unauthorized}
  def authorize(%Contest{} = contest, _, %User{} = user) do
    cond do
      contest.host_id in host_ids(user) -> :ok
      true -> {:error, :unauthorized}
    end
  end
  def authorize(Host, _, %User{}), do: {:error, :unauthorized}
  def authorize(User, _, %User{}), do: {:error, :unauthorized}

  def authorized?(target, action, user) do
    authorize(target, action, user) == :ok
  end

  # Scope-based rules
  def accessible_by(query, %User{role: "admin"}), do: query
  def accessible_by(query, %User{} = user) do
    from c in query, where: c.host_id in ^host_ids(user)
  end

  def unauthorized(conn) do
    conn
    |> put_flash(:warning,
      gettext("Please sign in with sufficient permissions to access this page."))
    |> redirect(to: page_path(conn, :home))
    |> halt()
  end

  defp host_ids(user) do
    user
    |> Repo.preload(:hosts)
    |> Map.get(:hosts)
    |> Enum.map(&(&1.id))
  end
end

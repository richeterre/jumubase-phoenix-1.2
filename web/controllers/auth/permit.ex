defmodule Jumubase.Permit.Plug do
  alias Jumubase.{Auth, Permit}

  def authorize_action(conn, opts) do
    user = conn.assigns.current_user
    action = conn.private[:phoenix_action]
    resource = Keyword.get(opts, :resource)

    case Permit.authorize(resource, action, user) do
      :ok -> conn
      {:error, :unauthorized} -> Auth.unauthorized(conn)
    end
  end
end

defmodule Jumubase.Permit do
  import Ecto.Query
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
  def authorize(%User{}, _, %User{}), do: {:error, :unauthorized}

  def authorized?(target, action, user) do
    authorize(target, action, user) == :ok
  end

  # Scope-based rules
  def accessible_by(query, %User{role: "admin"}), do: query
  def accessible_by(query, %User{} = user) do
    from c in query, where: c.host_id in ^host_ids(user)
  end

  defp host_ids(user) do
    user
    |> Jumubase.Repo.preload(:hosts)
    |> Map.get(:hosts)
    |> Enum.map(&(&1.id))
  end
end

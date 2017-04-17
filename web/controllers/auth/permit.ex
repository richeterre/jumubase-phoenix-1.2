defmodule Jumubase.Permit.Plug do
  alias Jumubase.{Auth, Permit}

  def authorize_action(conn, opts) do
    user = conn.assigns.current_user
    action = conn.private[:phoenix_action]
    resource = Keyword.get(opts, :resource)

    case Permit.authorize(user, action, resource) do
      :ok -> conn
      {:error, :unauthorized} -> Auth.unauthorized(conn)
    end
  end
end

defmodule Jumubase.Permit do
  import Ecto.Query
  alias Jumubase.{Contest, Performance, User}

  def authorized?(user, action, target) do
    authorize(user, action, target) == :ok
  end

  ## Action-based rules

  # Admins can do anything
  def authorize(%User{role: "admin"}, _, _), do: :ok

  # Contests
  def authorize(%User{}, :index, Contest), do: :ok
  def authorize(%User{}, :show, Contest), do: :ok
  def authorize(%User{} = user, :show, %Contest{} = contest) do
    if contest.host_id in host_ids(user), do: :ok, else: {:error, :unauthorized}
  end
  def authorize(%User{} = user, :list_performances, %Contest{} = contest) do
    if contest.host_id in host_ids(user), do: :ok, else: {:error, :unauthorized}
  end

  # Performances
  def authorize(%User{}, :index, Performance), do: :ok

  # Everything is forbidden by default
  def authorize(%User{}, _, _), do: {:error, :unauthorized}

  ## Scope-based rules

  # Contests
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

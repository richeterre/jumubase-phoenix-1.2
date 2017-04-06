defmodule Jumubase.AuthHelpers do
  use Phoenix.HTML

  def signed_in?(conn), do: Guardian.Plug.authenticated?(conn)
  def admin?(current_user), do: current_user.role === "admin"
end

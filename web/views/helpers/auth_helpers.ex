defmodule Jumubase.AuthHelpers do
  def signed_in?(conn), do: Guardian.Plug.authenticated?(conn)
  def admin?(current_user), do: current_user.role === "admin"
end

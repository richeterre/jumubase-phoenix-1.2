defmodule Jumubase.AuthHelpers do
  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def signed_in?(conn), do: Guardian.Plug.authenticated?(conn)
end

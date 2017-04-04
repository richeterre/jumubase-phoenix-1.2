defmodule Jumubase.Plug.CurrentUser do
  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    conn = Plug.Conn.assign(conn, :current_user, current_user)

    # Log out if no user could be found despite being authenticated
    case {current_user, Guardian.Plug.authenticated?(conn)} do
      {nil, true} ->
        Jumubase.Auth.logout(conn)
      _ ->
        conn
    end
  end
end

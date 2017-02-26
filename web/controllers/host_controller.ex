defmodule Jumubase.HostController do
  use Jumubase.Web, :controller
  alias Jumubase.Host

  def index(conn, _params) do
    conn
    |> assign(:hosts, Repo.all(Host))
    |> render("index.html")
  end
end

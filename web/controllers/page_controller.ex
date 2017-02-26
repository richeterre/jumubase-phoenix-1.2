defmodule Jumubase.PageController do
  use Jumubase.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

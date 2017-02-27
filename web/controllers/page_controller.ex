defmodule Jumubase.PageController do
  use Jumubase.Web, :controller

  def home(conn, _params) do
    render conn, "home.html"
  end
end

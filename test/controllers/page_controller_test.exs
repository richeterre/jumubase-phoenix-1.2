defmodule Jumubase.PageControllerTest do
  use Jumubase.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Jumu Nordost"
  end
end

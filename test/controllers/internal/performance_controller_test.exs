defmodule Jumubase.PerformanceControllerTest do
  use Jumubase.ConnCase
  alias Jumubase.JumuParams

  setup context do
    login_if_needed(context)
  end

  describe "a non-admin user" do
    for role <- List.delete(JumuParams.roles(), "admin") do
      @tag login_as: role
      test "(#{role}) can list performances of an associated contest", %{conn: conn, user: user} do
        contest = insert_associated_contest(user)
        conn = get conn, internal_contest_performance_path(conn, :index, contest)
        assert html_response(conn, 200)
      end

      @tag login_as: role
      test "(#{role}) cannot list performances of an unassociated contest", %{conn: conn} do
        contest = insert(:contest)
        conn = get(conn, internal_contest_performance_path(conn, :index, contest))
        assert_unauthorized(conn)
      end
    end
  end

  describe "an admin user" do
    @tag login_as: "admin"
    test "can list performances of an associated contest", %{conn: conn, user: user} do
      contest = insert_associated_contest(user)
      conn = get conn, internal_contest_performance_path(conn, :index, contest)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can list performances of an unassociated contest", %{conn: conn} do
      contest = insert(:contest)
      conn = get conn, internal_contest_performance_path(conn, :index, contest)
      assert html_response(conn, 200)
    end
  end
end

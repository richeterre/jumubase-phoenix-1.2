defmodule Jumubase.ContestControllerTest do
  use Jumubase.ConnCase
  alias Jumubase.JumuParams
  alias Jumubase.Internal.ContestView

  setup context do
    login_if_needed(context)
  end

  describe "a non-admin user" do
    for role <- List.delete(JumuParams.roles(), "admin") do
      @tag login_as: role
      test "(#{role}) can list only associated contests", %{conn: conn, user: user} do
        own_contest = insert_associated_contest(user)
        other_contest = insert(:contest)
        conn = get(conn, internal_contest_path(conn, :index))

        assert html_response(conn, 200)
        assert String.contains?(conn.resp_body, ContestView.name(own_contest))
        refute String.contains?(conn.resp_body, ContestView.name(other_contest))
      end

      @tag login_as: role
      test "(#{role}) cannot view an unassociated contest", %{conn: conn} do
        contest = insert(:contest)
        conn = get(conn, internal_contest_path(conn, :show, contest))
        assert_unauthorized(conn)
      end

      @tag login_as: role
      test "(#{role}) can view an associated contest", %{conn: conn, user: user} do
        contest = insert_associated_contest(user)
        conn = get(conn, internal_contest_path(conn, :show, contest))
        assert html_response(conn, 200)
      end

      @tag login_as: role
      test "(#{role}) cannot add new contests", %{conn: conn} do
        Enum.each([
          get(conn, internal_contest_path(conn, :new)),
          post(conn, internal_contest_path(conn, :create, %{}))
        ], fn conn ->
          assert_unauthorized(conn)
        end)
      end
    end
  end

  describe "an admin user" do
    @tag login_as: "admin"
    test "can list all contests", %{conn: conn, user: user} do
      own_contest = insert_associated_contest(user)
      other_contest = insert(:contest)
      conn = get(conn, internal_contest_path(conn, :index))

      assert html_response(conn, 200)
      assert String.contains?(conn.resp_body, ContestView.name(own_contest))
      assert String.contains?(conn.resp_body, ContestView.name(other_contest))
    end

    @tag login_as: "admin"
    test "can access the new contest form", %{conn: conn} do
      conn = get conn, internal_contest_path(conn, :new)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can create a new contest", %{conn: conn} do
      host = insert(:host)
      attrs = params_for(:contest) |> Map.put(:host_id, host.id)
      conn = post conn, internal_contest_path(conn, :create), contest: attrs

      assert redirected_to(conn) == internal_contest_path(conn, :index)
      assert Repo.get_by(Jumubase.Contest,
        %{season: attrs.season, round: attrs.round, host_id: attrs.host_id})
    end

    @tag login_as: "admin"
    test "can view any contest", %{conn: conn} do
      contest = insert(:contest)
      conn = get(conn, internal_contest_path(conn, :show, contest))
      assert html_response(conn, 200)
    end
  end
end

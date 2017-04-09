defmodule Jumubase.CategoryControllerTest do
  use Jumubase.ConnCase
  alias Jumubase.JumuParams

  setup context do
    login_if_needed(context)
  end

  describe "a non-admin user" do
    for role <- List.delete(JumuParams.roles(), "admin") do
      @tag login_as: role
      test "(#{role}) is redirected when trying to perform any category action", %{conn: conn} do
        Enum.each([
          get(conn, internal_category_path(conn, :index)),
          get(conn, internal_category_path(conn, :new)),
          get(conn, internal_category_path(conn, :create, %{}))
        ], fn conn ->
          assert_unauthorized(conn)
        end)
      end
    end
  end


  describe "an admin user" do
    @tag login_as: "admin"
    test "can list all categories", %{conn: conn} do
      conn = get conn, internal_category_path(conn, :index)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can access the new category form", %{conn: conn} do
      conn = get conn, internal_category_path(conn, :new)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can create a new category", %{conn: conn} do
      attrs = params_for(:category)
      conn = post conn, internal_category_path(conn, :create), category: attrs

      assert redirected_to(conn) == internal_category_path(conn, :index)
      assert Repo.get_by(Jumubase.Category, %{name: attrs.name})
    end
  end
end

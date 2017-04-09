defmodule Jumubase.UserControllerTest do
  use Jumubase.ConnCase
  alias Jumubase.JumuParams

  setup context do
    login_if_needed(context)
  end

  describe "a non-admin user" do
    for role <- List.delete(JumuParams.roles(), "admin") do
      @tag login_as: role
      test "(#{role}) is redirected when trying to perform any user action", %{conn: conn} do
        fake_id = "123"
        Enum.each([
          get(conn, internal_user_path(conn, :index)),
          get(conn, internal_user_path(conn, :new)),
          post(conn, internal_user_path(conn, :create, %{})),
          get(conn, internal_user_path(conn, :edit, fake_id)),
          put(conn, internal_user_path(conn, :update, fake_id, %{})),
          delete(conn, internal_user_path(conn, :delete, fake_id))
        ], fn conn ->
          assert_unauthorized(conn)
        end)
      end
    end
  end


  describe "an admin user" do
    @tag login_as: "admin"
    test "can list all users", %{conn: conn} do
      conn = get conn, internal_user_path(conn, :index)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can access the new user form", %{conn: conn} do
      conn = get conn, internal_user_path(conn, :new)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can create a new user", %{conn: conn} do
      attrs = params_for(:user, %{role: "rw-organizer"})
      conn = post conn, internal_user_path(conn, :create), user: attrs

      assert redirected_to(conn) == internal_user_path(conn, :index)
      assert Repo.get_by(Jumubase.User, %{email: attrs.email})
    end

    @tag login_as: "admin"
    test "can edit an existing user", %{conn: conn} do
      user = insert(:user)
      conn = get conn, internal_user_path(conn, :edit, user)

      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can update an existing user", %{conn: conn} do
      user = insert(:user)
      new_email = "new-email@example.org"
      attrs = Map.from_struct(user) |> Map.put(:email, new_email)
      conn = put conn, internal_user_path(conn, :update, user), user: attrs

      assert redirected_to(conn) == internal_user_path(conn, :index)
      assert Repo.get_by(Jumubase.User, %{email: new_email})
    end

    @tag login_as: "admin"
    test "can delete an existing user", %{conn: conn} do
      user = insert(:user)
      conn = delete conn, internal_user_path(conn, :delete, user)

      assert redirected_to(conn) == internal_user_path(conn, :index)
      refute Repo.get_by(Jumubase.User, %{email: user.email})
    end
  end
end

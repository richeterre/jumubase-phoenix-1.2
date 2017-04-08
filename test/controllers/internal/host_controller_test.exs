defmodule Jumubase.HostControllerTest do
  use Jumubase.ConnCase
  import Jumubase.Factory
  alias Jumubase.JumuParams

  setup %{conn: conn} = config do
    if user_role = config[:login_as] do
      conn = conn |> login_user(user_role)
      {:ok, %{conn: conn}}
    else
      {:ok, %{conn: conn}}
    end
  end

  describe "a non-admin user" do
    for role <- List.delete(JumuParams.roles(), "admin") do
      @tag login_as: role
      test "(#{role}) is redirected when trying to perform any host action", %{conn: conn} do
        Enum.each([
          get(conn, internal_host_path(conn, :index)),
          get(conn, internal_host_path(conn, :new)),
          get(conn, internal_host_path(conn, :create, %{}))
        ], fn conn ->
          assert_unauthorized(conn)
        end)
      end
    end
  end


  describe "an admin user" do
    @tag login_as: "admin"
    test "can list all hosts", %{conn: conn} do
      conn = get conn, internal_host_path(conn, :index)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can access the new host form", %{conn: conn} do
      conn = get conn, internal_host_path(conn, :new)
      assert html_response(conn, 200)
    end

    @tag login_as: "admin"
    test "can create a new host", %{conn: conn} do
      attrs = Map.from_struct(factory(:host))
      conn = post conn, internal_host_path(conn, :create), host: attrs

      assert redirected_to(conn) == internal_host_path(conn, :index)
      assert Repo.get_by(Jumubase.Host, %{name: attrs.name})
    end
  end

  defp login_user(conn, role) do
    {:ok, user} = Repo.insert(factory(:user, role))
    guardian_login(conn, user)
  end

  defp assert_unauthorized(conn) do
    assert redirected_to(conn) == page_path(conn, :home)
    assert conn.halted
  end
end

defmodule Jumubase.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Jumubase.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Jumubase.Router.Helpers

      # The default endpoint for testing
      @endpoint Jumubase.Endpoint

      # Log in user for integration testing
      def guardian_login(conn, user) do
        conn
        |> bypass_through(Jumubase.Router, [:browser])
        |> get("/")
        |> Jumubase.Auth.login(user)
        |> send_resp(200, "Flush the session")
        |> recycle()
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Jumubase.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Jumubase.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

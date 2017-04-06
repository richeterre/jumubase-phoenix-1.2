defmodule Jumubase.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Jumubase.Web, :controller
      use Jumubase.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      alias Jumubase.JumuParams
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Jumubase.Repo
      alias Jumubase.JumuParams
      alias Jumubase.Permit
      import Ecto
      import Ecto.Query

      import Jumubase.Router.Helpers
      import Jumubase.Gettext
      import Jumubase.Breadcrumbs
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]
      import Jumubase.Permit, only: [authorized?: 3]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      alias Jumubase.JumuParams
      import Jumubase.Router.Helpers
      import Jumubase.AuthHelpers
      import Jumubase.ErrorHelpers
      import Jumubase.IconHelpers
      import Jumubase.InputHelpers
      import Jumubase.LabelHelpers
      import Jumubase.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Jumubase.Repo
      import Ecto
      import Ecto.Query
      import Jumubase.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

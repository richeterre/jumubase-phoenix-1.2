defmodule Jumubase.Internal.Controller do
  defmacro __using__(_) do
    quote do
      def action(conn, _), do: Jumubase.Internal.Controller.__action__(__MODULE__, conn)
      defoverridable action: 2
    end
  end

  def __action__(controller, conn) do
    # Pass current user as param to all actions
    args = [conn, conn.params, conn.assigns.current_user]
    apply(controller, Phoenix.Controller.action_name(conn), args)
  end
end

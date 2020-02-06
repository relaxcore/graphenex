defmodule BitsharesReportingWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: BitsharesReportingWeb

      import Plug.Conn
      alias BitsharesReportingWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/bitshares_reporting_web/templates",
        namespace: BitsharesReportingWeb

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import BitsharesReportingWeb.ErrorHelpers
      alias BitsharesReportingWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

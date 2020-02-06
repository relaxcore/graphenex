defmodule BitsharesReporting.Application do
  use Application

  def start(_type, _args) do
    children = [
      BitsharesReporting.Repo,
      BitsharesReportingWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: BitsharesReporting.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    BitsharesReportingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

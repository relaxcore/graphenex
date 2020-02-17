defmodule Reporting.Application do
  use Application

  def start(_type, _args) do
    children = [
      Reporting.Repo,
    ]

    opts = [strategy: :one_for_one, name: Reporting.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(_changed, _new, _removed), do: :ok
end

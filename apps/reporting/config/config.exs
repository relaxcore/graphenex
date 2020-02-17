use Mix.Config

config :reporting,
  ecto_repos: [Reporting.Repo],
  generators: [binary_id: true]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Poison

import_config "#{Mix.env()}.exs"

use Mix.Config

config :bitshares_reporting,
  ecto_repos: [BitsharesReporting.Repo],
  generators: [binary_id: true]

config :bitshares_reporting, BitsharesReportingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "55lYtD5RonMpEu230p0hNxvwkOLt6WFw7143tCeTfw8JTH86LmLBsTpee1LMXlkk",
  render_errors: [view: BitsharesReportingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BitsharesReporting.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Poison

import_config "#{Mix.env()}.exs"

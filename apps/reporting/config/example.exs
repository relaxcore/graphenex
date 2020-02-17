use Mix.Config

config :reporting, Reporting.Repo,
  username: "postgres",
  password: "postgres",
  database: "graphenex_reporting_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime

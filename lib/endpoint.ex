defmodule BitsharesReportingWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :bitshares_reporting

  @session_options [
    store: :cookie,
    key: "_bitshares_reporting_key",
    signing_salt: "DS2qi0G4"
  ]

  plug Plug.Static,
    at: "/",
    from: :bitshares_reporting,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BitsharesReportingWeb.Router
end

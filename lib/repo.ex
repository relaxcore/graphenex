defmodule BitsharesReporting.Repo do
  use Ecto.Repo,
    otp_app: :bitshares_reporting,
    adapter: Ecto.Adapters.Postgres
end

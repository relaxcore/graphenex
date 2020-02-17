defmodule Reporting.Repo do
  use Ecto.Repo,
    otp_app: :reporting,
    adapter: Ecto.Adapters.Postgres
end

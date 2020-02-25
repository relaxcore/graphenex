defmodule Graphenex.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "1.0.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp deps,            do: []
  defp aliases,         do: [setup: base_setup() ++ reporting_setup()]
  defp base_setup,      do: ["ecto.create", "ecto.migrate"]
  defp reporting_setup, do: ["run apps/reporting/priv/repo/seeds.exs"]
end

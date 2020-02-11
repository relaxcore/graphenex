defmodule BitsharesReporting.MixProject do
  use Mix.Project

  def project do
    [
      app: :bitshares_reporting,
      version: "0.1.0",
      elixir: "~> 1.10.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {BitsharesReporting.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix,             "~> 1.4.12"},
      {:phoenix_pubsub,      "~> 1.1.2"},
      {:phoenix_ecto,        "~> 4.1.0"},
      {:ecto_sql,            "~> 3.3.3"},
      {:postgrex,            "~> 0.15.3"},
      {:poison,              "~> 4.0.1"},
      {:plug_cowboy,         "~> 2.1.2"},
      {:socket,              "~> 0.3.13"},
      {:httpoison,           "~> 1.6.2"},
      {:elixlsx,             "~> 0.4.2"},
      {:phoenix_live_reload, "~> 1.2.1", only: :dev},
      {:credo,               "~> 1.0.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end

defmodule Jumubase.Mixfile do
  use Mix.Project

  def project do
    [app: :jumubase,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Jumubase, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy,
     :logger, :gettext, :phoenix_ecto, :postgrex, :ex_machina, :timex,
     :absinthe, :absinthe_plug, :absinthe_ecto]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:comeonin, "~> 3.0"},
     {:guardian, "~> 0.14"},
     {:ex_machina, "~> 2.0"},
     {:timex, "~> 3.0"},
     {:timex_ecto, "~> 3.0"},
     {:absinthe, "~> 1.2.0"},
     {:absinthe_plug, "~> 1.2.0"},
     {:absinthe_ecto, git: "https://github.com/absinthe-graphql/absinthe_ecto.git"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end

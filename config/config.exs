# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

default_locale = "de"

# General application configuration
config :jumubase,
  ecto_repos: [Jumubase.Repo]
config :jumubase, Jumubase.Gettext,
  default_locale: default_locale

# Configures date/time formatting
config :timex,
  default_locale: default_locale

# Configures the endpoint
config :jumubase, Jumubase.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VHofhchy+ZPk47Qlq6dN1zao2XyqDOu2H1lu8JczVHcgSqBhGoCNrUUw8yG8FOEo",
  render_errors: [view: Jumubase.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Jumubase.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Jumubase",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  serializer: Jumubase.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

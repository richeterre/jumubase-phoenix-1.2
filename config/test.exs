use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :jumubase, Jumubase.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :jumubase, Jumubase.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "jumubase_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure Guardian
config :guardian, Guardian,
  secret_key: String.duplicate("x", 30)

# Make tests faster by tuning down the crypto
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

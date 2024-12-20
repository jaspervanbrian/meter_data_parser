import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :meter_data_parser, MeterDataParser.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "meter_data_parser_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :meter_data_parser, MeterDataParserWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "DAr2xn44si8fb5Oltzflfv/ayrqQvyAHtsIbVAgQqkx6wlgPnSWlEf/P411EQMbx",
  server: false

# In test we don't send emails
config :meter_data_parser, MeterDataParser.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :meter_data_parser, Oban, testing: :inline

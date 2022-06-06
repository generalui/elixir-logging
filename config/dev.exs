import Config

application_port = String.to_integer(System.get_env("PORT") || "4000")

database_url =
  System.get_env("DATABASE_URL") || "ecto://postgres:docker@localhost/elixir_logging_dev"

is_release = System.get_env("RELEASE")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise(
      "Environment variable SECRET_KEY_BASE is missing. Be sure to add it to the .env-dev file."
    )

website_host = System.get_env("WEBSITE_HOST") || "localhost"

json_logging = !(website_host == "localhost" and System.get_env("CONSOLE_LOGGING"))

config :elixir_logging,
  json_logging: json_logging,
  website_host: website_host

# Configure your database
config :elixir_logging, ElixirLogging.Repo,
  pool_size: String.to_integer(System.get_env("MAX_POOL") || "10"),
  # If the "RELEASE" environment variable is NOT set, show sensitive data on connection error.
  show_sensitive_data_on_connection_error: !is_release,
  # If running a local DB and it isn't set up for SSL, set this to `false`.
  ssl: false,
  stacktrace: true,
  url: database_url

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :elixir_logging, ElixirLoggingWeb.Endpoint,
  check_origin: false,
  # If the "RELEASE" environment variable is NOT set, enable code_reloader.
  # If it IS set, then code_reloader CANNOT be enabled as Mix is not available in a release.
  code_reloader: !is_release,
  # If the "RELEASE" environment variable is NOT set, debug errors.
  debug_errors: !is_release,
  http: [port: application_port],
  live_view: [signing_salt: secret_key_base],
  secret_key_base: secret_key_base,
  server: true,
  url: [host: website_host, port: application_port],
  watchers: []

if not json_logging do
  config :logger, backends: [:console]
  # Do not include metadata nor timestamps in development logs
  config :logger, :console, format: "[$level] $message\n"
end

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 50

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

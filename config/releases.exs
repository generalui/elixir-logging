import Config

# These environment variables MUST be captured in the release config for them to be available in the deployed app. The Environment variables will NOT be available yet during the environment build (config/{dev, staging, prod}.ex).

env = System.get_env("MIX_ENV") |> String.to_atom()
is_prod = env == :prod
is_dev = env == :dev
is_test = env == :test

application_port = String.to_integer(System.get_env("PORT") || "4000")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") || raise("environment variable SECRET_KEY_BASE is missing.")

website_host =
  System.get_env("WEBSITE_HOST") || raise("environment variable WEBSITE_HOST is missing.")

log_level =
  cond do
    is_dev -> :debug
    is_prod -> :info
    is_test -> :warn
  end

# Configurations the app itself
config :elixir_logging,
  base_url: "https://#{website_host}",
  env: env,
  scheme: "https",
  website_host: website_host

config :elixir_logging, ElixirLoggingWeb.Endpoint,
  http: [port: application_port, transport_options: [socket_opts: [:inet6]]],
  live_reload: [],
  live_view: [signing_salt: secret_key_base],
  reloadable_compilers: [],
  secret_key_base: secret_key_base,
  server: true,
  url: [host: website_host, port: 443]

config :phoenix, :stacktrace_depth, 8

# In release, write the tzdata to a read and writeable dir. See https://hexdocs.pm/tzdata/readme.html#data-directory-and-releases
config :tzdata, :data_dir, "/data"

config :logger_json, :backend, on_init: {ElixirLogging.Logs.Logger, :load_config, [env]}

# Configures Elixir's Logger
config :logger, backends: [LoggerJSON], level: log_level

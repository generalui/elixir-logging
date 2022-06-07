import Config

application_port = 4002

# This value is hardcoded for test.
secret_key_base = "LLRgjeeWvf1K1U0vsGVCESK4AcTD2lXnL1x13SLiac7XW4UhwW2PWaxE+ejIMeUs"

website_host = System.get_env("WEBSITE_HOST") || "localhost"

scheme = if website_host != "localhost", do: "https", else: "http"

json_logging = !(website_host == "localhost" and System.get_env("CONSOLE_LOGGING"))

config :elixir_logging,
  base_url: "#{scheme}://#{website_host}:#{application_port}/",
  json_logging: json_logging,
  website_host: website_host

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_logging, ElixirLoggingWeb.Endpoint,
  http: [port: application_port],
  live_view: [signing_salt: secret_key_base],
  secret_key_base: secret_key_base,
  server: false,
  url: [host: website_host, port: application_port]

if not json_logging do
  config :logger, backends: [:console]
  # Do not include metadata nor timestamps in development logs
  config :logger, :console, format: "[$level] $message\n"
end

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

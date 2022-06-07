# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

env = config_env()
is_prod = env == :prod
is_dev = env == :dev
is_test = env == :test

log_level =
  cond do
    is_dev -> :debug
    is_prod -> :info
    is_test -> :warn
  end

# Load the environment variables from the appropriate .env file.
env_ext = if is_prod, do: "", else: "-#{env}"

try do
  # In case .env file does not exist.
  File.stream!("./.env#{env_ext}")
  # Remove excess whitespace
  |> Stream.map(&String.trim_trailing/1)
  # Loop through each line
  |> Enum.each(fn line ->
    line
    # Split on *first* "=" (equals sign)
    |> String.split("=", parts: 2)
    # stackoverflow.com/q/33055834/1148249
    |> Enum.reduce(fn value, key ->
      # Skip all comments
      if key |> String.starts_with?("#") == false do
        # Set each environment variable
        System.put_env(key, value)
      end
    end)
  end)
rescue
  _ ->
    IO.puts(
      IO.ANSI.yellow() <>
        "There was no `.env#{env_ext}` file found. Please ensure the required environment variables have been set." <>
        IO.ANSI.reset()
    )
end

config :elixir_logging,
  env: env,
  json_logging: true

# Configures the endpoint
config :elixir_logging, ElixirLoggingWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/gettext/.*(po)$},
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg|json)$},
      ~r{lib/elixir_logging_web/controllers/.*(ex)$},
      ~r{lib/elixir_logging_web/templates/.*(eex)$},
      ~r{lib/elixir_logging_web/views/.*(ex)$}
    ]
  ],
  pubsub_server: ReactMobile.PubSub,
  reloadable_compilers: [:gettext, :phoenix, :elixir, :phoenix_swagger],
  render_errors: [view: ElixirLoggingWeb.ErrorView, accepts: ~w(html json), layout: false],
  url: [host: "localhost"]

config :logger_json, :backend, on_init: {ElixirLogging.Logs.Logger, :load_config, [level: log_level]}

# Configures Elixir's Logger
config :logger, backends: [LoggerJSON], level: log_level

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{env}.exs"

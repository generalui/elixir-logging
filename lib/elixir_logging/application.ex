defmodule ElixirLogging.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # if Application.fetch_env!(:elixir_logging, :json_logging) do
    #   :ok =
    #     :telemetry.attach(
    #       "logger-json-ecto",
    #       [:elixir_logging, :repo, :query],
    #       &LoggerJSON.Ecto.telemetry_logging_handler/4,
    #       :debug
    #     )
    # end
    children = [
      # Start the Telemetry supervisor
      ElixirLogging.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirLogging.PubSub},
      # Start the Endpoint (http/https)
      ElixirLoggingWeb.Endpoint
      # Start a worker by calling: ElixirLogging.Worker.start_link(arg)
      # {ElixirLogging.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirLogging.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirLoggingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

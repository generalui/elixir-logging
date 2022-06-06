defmodule ElixirLogging.Repo do
  use Ecto.Repo,
    otp_app: :elixir_logging,
    adapter: Ecto.Adapters.Postgres
end

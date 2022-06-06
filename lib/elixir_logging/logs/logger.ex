defmodule ElixirLogging.Logs.Logger do
  @moduledoc """
  Includes functions for dynamically configuring logging.
  See: https://hexdocs.pm/logger_json/LoggerJSON.html#module-dynamic-configuration
  """

  alias ElixirLogging.Utils.List
  alias ElixirLogging.Logs.Formatter

  @default [formatter: Formatter, json_encoder: Jason, level: :debug, metadata: :all]

  def load_config(_, [:prod]) do
    config = @default |> List.merge_keyword_lists(:level, :info)
    {:ok, config}
  end

  def load_config(_, [:test]) do
    config = @default |> List.merge_keyword_lists(:level, :warn)
    {:ok, config}
  end

  def load_config(_, _) do
    {:ok, @default}
  end
end

defmodule ElixirLogging.Logs.Logger do
  @moduledoc """
  Includes functions for dynamically configuring logging.
  See: https://hexdocs.pm/logger_json/LoggerJSON.html#module-dynamic-configuration
  """

  alias ElixirLogging.Logs.Formatter

  @default [formatter: Formatter, json_encoder: Jason, level: :debug, metadata: :all]

  def load_config(_, {:level, level}) do
    config = @default |> merge_keyword_lists(:level, level)
    {:ok, config}
  end

  def load_config(_, _) do
    {:ok, @default}
  end

  defp merge_keyword_lists(primary, key, value) do
    try do
      Keyword.replace!(primary, key, value)
    rescue
      _ -> [{key, value} | primary]
    end
  end
end

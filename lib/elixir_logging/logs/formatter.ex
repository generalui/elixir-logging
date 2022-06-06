defmodule ElixirLogging.Logs.Formatter do
  @moduledoc """
  JSON log formatter.
  See: https://github.com/Nebo15/logger_json/blob/master/lib/logger_json/formatters/basic_logger.ex
  """

  import Jason.Helpers, only: [json_map: 1]

  alias LoggerJSON.{FormatterUtils, JasonSafeFormatter}

  @behaviour LoggerJSON.Formatter

  @processed_metadata_keys ~w[pid file line function module application]a

  @impl true
  def format_event(level, msg, ts, md, md_keys) do
    json_map(
      severity: Atom.to_string(level),
      time: FormatterUtils.format_timestamp(ts),
      message: IO.chardata_to_string(msg),
      metadata: format_metadata(md, md_keys)
    )
  end

  defp format_metadata(md, md_keys) do
    md
    |> LoggerJSON.take_metadata(md_keys, @processed_metadata_keys)
    |> FormatterUtils.maybe_put(:error, FormatterUtils.format_process_crash(md))
    |> JasonSafeFormatter.format()
  end
end

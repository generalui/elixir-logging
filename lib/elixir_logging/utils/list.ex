defmodule ElixirLogging.Utils.List do
  @moduledoc """
  Utilities to aid in the processing of lists
  """

  def merge_keyword_lists(primary, key, value) do
    try do
      Keyword.replace!(primary, key, value)
    rescue
      _ -> [{key, value} | primary]
    end
  end
end

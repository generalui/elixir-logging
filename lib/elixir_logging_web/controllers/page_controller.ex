defmodule ElixirLoggingWeb.PageController do
  use ElixirLoggingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

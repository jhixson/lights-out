defmodule LightsOutWeb.PageController do
  use LightsOutWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

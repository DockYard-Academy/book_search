defmodule BookSearchWeb.PageController do
  use BookSearchWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

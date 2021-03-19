defmodule MaWeb.DemoController do
  use MaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

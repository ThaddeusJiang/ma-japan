defmodule MaWeb.StaticController do
  use MaWeb, :controller

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def price(conn, _params) do
    render(conn, "price.html")
  end
end

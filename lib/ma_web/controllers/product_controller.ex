defmodule MaWeb.ProductController do
  use MaWeb, :controller

  alias Ma.Products

  def index(conn, _params) do
    render(conn, "index.html", values: Products.list_businesses())
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", value: Products.get_business!(id))
  end
end

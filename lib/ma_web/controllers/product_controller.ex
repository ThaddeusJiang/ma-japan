defmodule MaWeb.ProductController do
  use MaWeb, :controller

  alias Ma.Products

  def index(conn, _params) do
    render(conn, "index.html", values: Products.list_businesses())
  end

  def show(conn, %{"id" => id}) do
    business = Products.get_business!(id)
    {:ok, business} = Products.inc_view_count(business)
    render(conn, "show.html", value: business)
  end
end

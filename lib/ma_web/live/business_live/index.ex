defmodule MaWeb.BusinessLive.Index do
  use MaWeb, :live_view

  alias Ma.Products
  alias Ma.Products.Business

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :businesses, list_businesses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Business")
    |> assign(:business, Products.get_business!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Business")
    |> assign(:business, %Business{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Businesses")
    |> assign(:business, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    business = Products.get_business!(id)
    {:ok, _} = Products.delete_business(business)

    {:noreply, assign(socket, :businesses, list_businesses())}
  end

  defp list_businesses do
    Products.list_businesses()
  end
end

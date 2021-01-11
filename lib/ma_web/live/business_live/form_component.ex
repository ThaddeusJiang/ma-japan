defmodule MaWeb.BusinessLive.FormComponent do
  use MaWeb, :live_component

  alias Ma.Products

  @impl true
  def update(%{business: business} = assigns, socket) do
    changeset = Products.change_business(business)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"business" => business_params}, socket) do
    changeset =
      socket.assigns.business
      |> Products.change_business(business_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"business" => business_params}, socket) do
    save_business(socket, socket.assigns.action, business_params)
  end

  defp save_business(socket, :edit, business_params) do
    case Products.update_business(socket.assigns.business, business_params) do
      {:ok, _business} ->
        {:noreply,
         socket
         |> put_flash(:info, "Business updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_business(socket, :new, business_params) do
    case Products.create_business(business_params) do
      {:ok, _business} ->
        {:noreply,
         socket
         |> put_flash(:info, "Business created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

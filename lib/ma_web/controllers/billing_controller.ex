defmodule MaWeb.BillingController do
  use MaWeb, :controller

  def new(conn, _params) do
    user = conn.assigns.current_user

    customer_id = customer_id(user.customer_id, user.email)
    require Logger
    Logger.debug(customer_id)

    params = %{
      customer: customer_id,
      success_url: "http://localhost:4000/settings/billing/checkout/success",
      cancel_url: "http://localhost:4000/settings/billing/checkout/failure",
      payment_method_types: ["card"],
      line_items: [
        %{
          price: "price_1ID0BiGRaO6xlSVQg1IBVfi6",
          quantity: 1
        }
      ],
      mode: "subscription"
    }

    {:ok, session} = Stripe.Session.create(params)

    render(conn, "new.html", session: session)
  end

  def success(conn, _pramas) do
    render(conn, "success.html")
  end

  def failure(conn, _params) do
    render(conn, "failure.html")
  end

  defp customer_id(nil, email) do
    new_customer = %{
      email: email
    }

    {:ok, stripe_customer} = Stripe.Customer.create(new_customer)

    stripe_customer.id
  end

  defp customer_id(id, _) do
    id
  end
end

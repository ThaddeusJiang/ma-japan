defmodule MaWeb.BillingController do
  use MaWeb, :controller

  def new(conn, _params) do
    params = %{
      customer: "cus_IofxqtT9HQC2E4",
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
end

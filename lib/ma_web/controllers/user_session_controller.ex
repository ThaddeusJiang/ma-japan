defmodule MaWeb.UserSessionController do
  use MaWeb, :controller

  alias Ma.Accounts
  alias MaWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  def manage(conn, _) do
    new_customer = %{
      email: "thaddeusjiang@gmail.com"
    }

    {:ok, stripe_customer} = Stripe.Customer.create(new_customer)

    params = %{
      customer: stripe_customer.id,
      return_url: "http://localhost:4000"
    }

    {:ok, portal_session} = Stripe.BillingPortal.Session.create(params)

    conn
    |> redirect(external: portal_session.url)
  end
end

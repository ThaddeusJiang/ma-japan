defmodule MaWeb.UserSettingsController do
  use MaWeb, :controller

  alias Ma.Accounts
  alias MaWeb.UserAuth

  plug :assign_email_and_password_changesets

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def billing(conn, _params) do
    render(conn, "billing.html")
  end

  def manage(conn, _) do
    user = conn.assigns.current_user

    customer_id = customer_id(user.customer_id, user.email)

    host = System.get_env("HOST", "http://localhost:4000")

    require Logger
    Logger.info(host)

    params = %{
      customer: customer_id,
      return_url: "#{host}/settings"
    }

    {:ok, portal_session} = Stripe.BillingPortal.Session.create(params)

    conn
    |> redirect(external: portal_session.url)
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

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  # 修改 email
  # 这个功能应该禁止
  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Accounts.change_user_email(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end

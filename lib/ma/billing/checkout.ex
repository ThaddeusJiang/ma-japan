defmodule Ma.Billing.Checkout do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checkouts" do
    field :email, :string
    field :plan, :string
    field :stripe_customer_id, :string
    field :subscription_status, :string

    timestamps()
  end

  @doc false
  def changeset(checkout, attrs) do
    checkout
    |> cast(attrs, [:email, :plan, :stripe_customer_id, :subscription_status])
    |> validate_required([:email, :plan, :stripe_customer_id, :subscription_status])
  end
end

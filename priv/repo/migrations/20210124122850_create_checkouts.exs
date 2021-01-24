defmodule Ma.Repo.Migrations.CreateCheckouts do
  use Ecto.Migration

  def change do
    create table(:checkouts) do
      add :email, :string
      add :plan, :string
      add :stripe_customer_id, :string
      add :subscription_status, :string, default: "incomplete"

      timestamps()
    end

  end
end

defmodule Ma.Repo.Migrations.AddPaymentToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :customer_id, :string
    end
  end
end

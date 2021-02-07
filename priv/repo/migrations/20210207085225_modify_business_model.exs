defmodule Ma.Repo.Migrations.ModifyBusinessModel do
  use Ecto.Migration

  def change do
    alter table(:businesses) do
      add :industry, :string, default: ""
      add :trade_deadline, :string, default: ""
      add :min_year_revenue, :integer
      add :max_year_revenue, :integer
    end
  end
end

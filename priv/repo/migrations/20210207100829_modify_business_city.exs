defmodule Ma.Repo.Migrations.ModifyBusinessCity do
  use Ecto.Migration

  def change do
    alter table(:businesses) do
      add :city, :string, default: ""
    end
  end
end

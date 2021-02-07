defmodule Ma.Repo.Migrations.CreateBusinesses do
  use Ecto.Migration

  def change do
    create table(:businesses) do
      add :name, :string
      add :public, :boolean, default: false, null: false
      add :public_date, :date
      add :view_count, :integer
      add :like_count, :integer
      add :summary, :string
      add :min_price, :integer
      add :max_price, :integer
      add :category, :string
      add :personal, :boolean, default: false, null: false
      add :pr, :string
      add :main_image, :string
      add :images, :string

      timestamps()
    end

  end
end

defmodule Ma.Products.Business do
  use Ecto.Schema
  import Ecto.Changeset

  schema "businesses" do
    field :main_image, :string, default: ""
    field :name, :string
    field :summary, :string, default: ""
    field :pr, :string
    field :category, :string
    field :personal, :boolean, default: false
    field :images, :string, default: ""
    field :max_price, :integer
    field :min_price, :integer
    field :public, :boolean, default: false
    field :public_date, :date
    field :view_count, :integer, default: 0
    field :like_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 250)
  end
end

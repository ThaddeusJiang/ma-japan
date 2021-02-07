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
    field :min_price, :integer
    # 价格上限
    field :max_price, :integer
    field :public, :boolean, default: false
    field :public_date, :date
    field :view_count, :integer, default: 0
    field :like_count, :integer, default: 0
    # 行业
    field :industry, :string, default: ""
    # 交易截止时间
    field :trade_deadline, :string, default: ""
    field :min_year_revenue, :integer
    # 营业额
    field :max_year_revenue, :integer
    # 城市
    field :city, :string, default: ""

    timestamps()
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [
      :name,
      :summary,
      :pr,
      :category,
      :personal,
      :min_price,
      :max_price,
      :public,
      :industry,
      :trade_deadline,
      :min_year_revenue,
      :max_year_revenue,
      :city
    ])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 250)
  end

  def inc_view_count(business) do
    business
    |> cast(%{view_count: business.view_count + 1}, [:view_count])
  end
end

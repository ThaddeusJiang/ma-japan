defmodule Ma.ProductsTest do
  use Ma.DataCase

  alias Ma.Products

  describe "businesses" do
    alias Ma.Products.Business

    @valid_attrs %{category: "some category", images: "some images", like_count: 42, main_image: "some main_image", max_price: 42, min_price: 42, name: "some name", personal: true, pr: "some pr", public: true, public_date: ~D[2010-04-17], summary: "some summary", view_count: 42}
    @update_attrs %{category: "some updated category", images: "some updated images", like_count: 43, main_image: "some updated main_image", max_price: 43, min_price: 43, name: "some updated name", personal: false, pr: "some updated pr", public: false, public_date: ~D[2011-05-18], summary: "some updated summary", view_count: 43}
    @invalid_attrs %{category: nil, images: nil, like_count: nil, main_image: nil, max_price: nil, min_price: nil, name: nil, personal: nil, pr: nil, public: nil, public_date: nil, summary: nil, view_count: nil}

    def business_fixture(attrs \\ %{}) do
      {:ok, business} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_business()

      business
    end

    test "list_businesses/0 returns all businesses" do
      business = business_fixture()
      assert Products.list_businesses() == [business]
    end

    test "get_business!/1 returns the business with given id" do
      business = business_fixture()
      assert Products.get_business!(business.id) == business
    end

    test "create_business/1 with valid data creates a business" do
      assert {:ok, %Business{} = business} = Products.create_business(@valid_attrs)
      assert business.category == "some category"
      assert business.images == "some images"
      assert business.like_count == 42
      assert business.main_image == "some main_image"
      assert business.max_price == 42
      assert business.min_price == 42
      assert business.name == "some name"
      assert business.personal == true
      assert business.pr == "some pr"
      assert business.public == true
      assert business.public_date == ~D[2010-04-17]
      assert business.summary == "some summary"
      assert business.view_count == 42
    end

    test "create_business/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_business(@invalid_attrs)
    end

    test "update_business/2 with valid data updates the business" do
      business = business_fixture()
      assert {:ok, %Business{} = business} = Products.update_business(business, @update_attrs)
      assert business.category == "some updated category"
      assert business.images == "some updated images"
      assert business.like_count == 43
      assert business.main_image == "some updated main_image"
      assert business.max_price == 43
      assert business.min_price == 43
      assert business.name == "some updated name"
      assert business.personal == false
      assert business.pr == "some updated pr"
      assert business.public == false
      assert business.public_date == ~D[2011-05-18]
      assert business.summary == "some updated summary"
      assert business.view_count == 43
    end

    test "update_business/2 with invalid data returns error changeset" do
      business = business_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_business(business, @invalid_attrs)
      assert business == Products.get_business!(business.id)
    end

    test "delete_business/1 deletes the business" do
      business = business_fixture()
      assert {:ok, %Business{}} = Products.delete_business(business)
      assert_raise Ecto.NoResultsError, fn -> Products.get_business!(business.id) end
    end

    test "change_business/1 returns a business changeset" do
      business = business_fixture()
      assert %Ecto.Changeset{} = Products.change_business(business)
    end
  end
end

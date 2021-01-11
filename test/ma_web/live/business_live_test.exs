defmodule MaWeb.BusinessLiveTest do
  use MaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Ma.Products

  @create_attrs %{category: "some category", images: "some images", like_count: 42, main_image: "some main_image", max_price: 42, min_price: 42, name: "some name", personal: true, pr: "some pr", public: true, public_date: ~D[2010-04-17], summary: "some summary", view_count: 42}
  @update_attrs %{category: "some updated category", images: "some updated images", like_count: 43, main_image: "some updated main_image", max_price: 43, min_price: 43, name: "some updated name", personal: false, pr: "some updated pr", public: false, public_date: ~D[2011-05-18], summary: "some updated summary", view_count: 43}
  @invalid_attrs %{category: nil, images: nil, like_count: nil, main_image: nil, max_price: nil, min_price: nil, name: nil, personal: nil, pr: nil, public: nil, public_date: nil, summary: nil, view_count: nil}

  defp fixture(:business) do
    {:ok, business} = Products.create_business(@create_attrs)
    business
  end

  defp create_business(_) do
    business = fixture(:business)
    %{business: business}
  end

  describe "Index" do
    setup [:create_business]

    test "lists all businesses", %{conn: conn, business: business} do
      {:ok, _index_live, html} = live(conn, Routes.business_index_path(conn, :index))

      assert html =~ "Listing Businesses"
      assert html =~ business.category
    end

    test "saves new business", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.business_index_path(conn, :index))

      assert index_live |> element("a", "New Business") |> render_click() =~
               "New Business"

      assert_patch(index_live, Routes.business_index_path(conn, :new))

      assert index_live
             |> form("#business-form", business: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#business-form", business: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.business_index_path(conn, :index))

      assert html =~ "Business created successfully"
      assert html =~ "some category"
    end

    test "updates business in listing", %{conn: conn, business: business} do
      {:ok, index_live, _html} = live(conn, Routes.business_index_path(conn, :index))

      assert index_live |> element("#business-#{business.id} a", "Edit") |> render_click() =~
               "Edit Business"

      assert_patch(index_live, Routes.business_index_path(conn, :edit, business))

      assert index_live
             |> form("#business-form", business: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#business-form", business: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.business_index_path(conn, :index))

      assert html =~ "Business updated successfully"
      assert html =~ "some updated category"
    end

    test "deletes business in listing", %{conn: conn, business: business} do
      {:ok, index_live, _html} = live(conn, Routes.business_index_path(conn, :index))

      assert index_live |> element("#business-#{business.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#business-#{business.id}")
    end
  end

  describe "Show" do
    setup [:create_business]

    test "displays business", %{conn: conn, business: business} do
      {:ok, _show_live, html} = live(conn, Routes.business_show_path(conn, :show, business))

      assert html =~ "Show Business"
      assert html =~ business.category
    end

    test "updates business within modal", %{conn: conn, business: business} do
      {:ok, show_live, _html} = live(conn, Routes.business_show_path(conn, :show, business))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Business"

      assert_patch(show_live, Routes.business_show_path(conn, :edit, business))

      assert show_live
             |> form("#business-form", business: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#business-form", business: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.business_show_path(conn, :show, business))

      assert html =~ "Business updated successfully"
      assert html =~ "some updated category"
    end
  end
end

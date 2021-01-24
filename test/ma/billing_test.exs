defmodule Ma.BillingTest do
  use Ma.DataCase

  alias Ma.Billing

  describe "checkouts" do
    alias Ma.Billing.Checkout

    @valid_attrs %{email: "some email", plan: "some plan", stripe_customer_id: "some stripe_customer_id", subscription_status: "some subscription_status"}
    @update_attrs %{email: "some updated email", plan: "some updated plan", stripe_customer_id: "some updated stripe_customer_id", subscription_status: "some updated subscription_status"}
    @invalid_attrs %{email: nil, plan: nil, stripe_customer_id: nil, subscription_status: nil}

    def checkout_fixture(attrs \\ %{}) do
      {:ok, checkout} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_checkout()

      checkout
    end

    test "list_checkouts/0 returns all checkouts" do
      checkout = checkout_fixture()
      assert Billing.list_checkouts() == [checkout]
    end

    test "get_checkout!/1 returns the checkout with given id" do
      checkout = checkout_fixture()
      assert Billing.get_checkout!(checkout.id) == checkout
    end

    test "create_checkout/1 with valid data creates a checkout" do
      assert {:ok, %Checkout{} = checkout} = Billing.create_checkout(@valid_attrs)
      assert checkout.email == "some email"
      assert checkout.plan == "some plan"
      assert checkout.stripe_customer_id == "some stripe_customer_id"
      assert checkout.subscription_status == "some subscription_status"
    end

    test "create_checkout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_checkout(@invalid_attrs)
    end

    test "update_checkout/2 with valid data updates the checkout" do
      checkout = checkout_fixture()
      assert {:ok, %Checkout{} = checkout} = Billing.update_checkout(checkout, @update_attrs)
      assert checkout.email == "some updated email"
      assert checkout.plan == "some updated plan"
      assert checkout.stripe_customer_id == "some updated stripe_customer_id"
      assert checkout.subscription_status == "some updated subscription_status"
    end

    test "update_checkout/2 with invalid data returns error changeset" do
      checkout = checkout_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_checkout(checkout, @invalid_attrs)
      assert checkout == Billing.get_checkout!(checkout.id)
    end

    test "delete_checkout/1 deletes the checkout" do
      checkout = checkout_fixture()
      assert {:ok, %Checkout{}} = Billing.delete_checkout(checkout)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_checkout!(checkout.id) end
    end

    test "change_checkout/1 returns a checkout changeset" do
      checkout = checkout_fixture()
      assert %Ecto.Changeset{} = Billing.change_checkout(checkout)
    end
  end
end

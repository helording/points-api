defmodule PointsApi.AdminTest do
  use PointsApi.DataCase

  alias PointsApi.Admin

  describe "customers" do
    alias PointsApi.Admin.Customer

    import PointsApi.AdminFixtures

    @invalid_attrs %{balance: nil, email: nil, phone: nil}

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Admin.list_customers() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Admin.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      valid_attrs = %{balance: 42, email: "some email", phone: "some phone"}

      assert {:ok, %Customer{} = customer} = Admin.create_customer(valid_attrs)
      assert customer.balance == 42
      assert customer.email == "some email"
      assert customer.phone == "some phone"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      update_attrs = %{balance: 43, email: "some updated email", phone: "some updated phone"}

      assert {:ok, %Customer{} = customer} = Admin.update_customer(customer, update_attrs)
      assert customer.balance == 43
      assert customer.email == "some updated email"
      assert customer.phone == "some updated phone"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_customer(customer, @invalid_attrs)
      assert customer == Admin.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Admin.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Admin.change_customer(customer)
    end
  end
end

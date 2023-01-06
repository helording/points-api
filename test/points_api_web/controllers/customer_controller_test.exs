defmodule PointsApiWeb.CustomerControllerTest do
  use PointsApiWeb.ConnCase

  import PointsApi.AdminFixtures

  alias PointsApi.Admin.Customer

  @create_attrs %{
    "balance" => 42,
    "email" => "s@s",
    "phone" => "123"
  }

  @customer_no_balance %{
    "email" => "s@s",
    "phone" => "123"
  }

  @update_attrs %{
    "balance" => 43,
    "email" => "s@s",
    "phone" => "123"
  }

  @invalid_attrs %{
    balance: nil,
    email: nil,
    phone: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all customers", %{conn: conn} do
      conn = get(conn, Routes.customer_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create customer" do
    test "renders customer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @create_attrs)
      # dafuq they pulling id from ?!?!?!?
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "balance" => 42,
               "email" => "s@s",
               "phone" => "123"
             } = json_response(conn, 200)["data"]

    end

    test "renders customer when + in number", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: %{"balance" => 42,"email" => "s@s","phone" => "+12392323"})
      # dafuq they pulling id from ?!?!?!?
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "balance" => 42,
               "email" => "s@s",
               "phone" => "+12392323"
             } = json_response(conn, 200)["data"]

    end

    test "renders customer information when customer already exist", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "balance" => 42,
               "email" => "s@s",
               "phone" => "123"
             } = json_response(conn, 200)["data"]

      conn = post(conn, Routes.customer_path(conn, :create), customer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
              "id" => ^id,
              "balance" => 42,
              "email" => "s@s",
              "phone" => "123"
            } = json_response(conn, 200)["data"]
    end

    test "renders customer with no balance provided", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @customer_no_balance)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "balance" => 0,
               "email" => "s@s",
               "phone" => "123"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when email and phone is null", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: @invalid_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "renders errors when email is invalid type", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: %{"email" => "aa", "phone" => "321"})
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "renders errors when phone is invalid type", %{conn: conn} do
      conn = post(conn, Routes.customer_path(conn, :create), customer: %{"email" => "a@a", "phone" => "adasd"})
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "update customer" do
    setup [:create_customer]

    test "renders customer when data is valid", %{conn: conn, customer: %Customer{id: id} = customer} do
      conn = put(conn, Routes.customer_path(conn, :update), customer: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.customer_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "balance" => 43,
               "email" => "s@s",
               "phone" => "123"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, customer: customer} do
      conn = put(conn, Routes.customer_path(conn, :update), customer: @invalid_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "delete customer" do
    setup [:create_customer]

    test "deletes chosen customer through email or phone", %{conn: conn, customer: customer} do
      conn = delete(conn, Routes.customer_path(conn, :delete), customer: @create_attrs)
      assert response(conn, 204)

      assert_error_sent 400, fn ->
        get(conn, Routes.customer_path(conn, :show, customer.email))
      end
    end

    test "deletes chosen customer struct", %{conn: conn, customer: customer} do
      conn = delete(conn, Routes.customer_path(conn, :delete, customer.id), customer: customer)
      assert response(conn, 204)

      assert_error_sent 400, fn ->
        get(conn, Routes.customer_path(conn, :show, customer.email))
      end
    end
  end

  defp create_customer(_) do
    customer = customer_fixture()
    %{customer: customer}
  end

end

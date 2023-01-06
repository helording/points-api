defmodule PointsApiWeb.OrderController do
  use PointsApiWeb, :controller

  alias PointsApi.Admin
  alias PointsApiWeb.ControllerHelpers

  action_fallback PointsApiWeb.FallbackController

  def create(conn, %{"order" => %{"paid" => amount} = order, "customer" => customer}) do
    percentage = Map.get(order, "percentage", 1)

    case Admin.get_customer(customer) do
      nil ->
        conn
        |> put_status(:bad_request)
        |> render("show.json", error: "Customer does not exist")
        |> halt()

      customer ->
        case Admin.update_customer(customer, %{balance: customer.balance + (div(amount,100)*percentage)}) do
          {:ok, update_customer} ->
            conn
            |> put_status(:accepted)
            |> render("show.json", order: %{balance_before: customer.balance, balance_after: update_customer.balance})
          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> render("show.json", error: ControllerHelpers.changeset_error_to_string(changeset))
            |> halt()
        end
    end
  end

"""
Not standard
  def create(conn, %{"order" => %{"paid" => amount}, "customer" => customer}) do
    create(conn, %{"order" => %{"paid" => amount, "percentage" => 1}, "customer" => customer})
  end
"""
end

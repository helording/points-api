defmodule PointsApiWeb.OrderController do
  use PointsApiWeb, :controller

  alias PointsApi.Admin

  action_fallback PointsApiWeb.FallbackController

  def create(conn, %{"order" => %{"paid" => amount}, "customer" => customer}) do

    case Admin.get_customer(customer) do
      nil ->
        conn
        |> put_status(:conflict)
        |> render("show.json", error: "Customer does not exist")
        |> halt()

      customer ->
        updated_balance = customer.balance + div(amount,100)
        cond do
          updated_balance >= 0 ->
            Admin.update_customer(customer, %{balance: updated_balance})
            conn
            |> put_status(:accepted)
            |> render("show.json", order: %{balance_before: customer.balance, balance_after: updated_balance})
          updated_balance < 0 ->
            conn
            |> put_status(:bad_request)
            |> render("show.json", error: "Balance out of range")
            |> halt()
        end
    end
  end

end

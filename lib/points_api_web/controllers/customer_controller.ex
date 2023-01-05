defmodule PointsApiWeb.CustomerController do
  use PointsApiWeb, :controller

  alias PointsApi.Admin
  alias PointsApi.Admin.Customer

  action_fallback PointsApiWeb.FallbackController

  # for debugging purposes
"""
    IO.puts "============"
    IO.inspect result
    IO.puts "============"
"""

  def index(conn, _params) do
    customers = Admin.list_customers()
    render(conn, "index.json", customers: customers)
  end

  def create(conn, %{"customer" => customer}) do

    result = case Admin.get_customer(customer) do
      nil -> Admin.create_customer(Map.put(customer, "balance", 0))
      customer -> {:ok, customer}
    end

    case result do
      {:error, changeset} ->
        conn
        |> put_status(:conflict)
        #|> put_resp_header("location", Routes.customer_path(conn, :show, changeset_error_to_string(changeset)))
        |> render("show.json", error: changeset_error_to_string(changeset))
      {:ok, customer} ->
        conn
        |> put_status(:created)
        #|> put_resp_header("location", Routes.customer_path(conn, :show, customer))
        |> render("show.json", customer: customer)
    end
  end

  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end

  def show(conn, %{"id" => id}) do
    customer = Admin.get_customer!(id)
    render(conn, "show.json", customer: customer)
  end

  def show(conn, %{"email" => email}) do
    case Admin.get_customer(%{"email" => email, "phone" => nil}) do
      nil -> render(conn, "show.json", error: "No customer with that email")
      customer -> render(conn, "show.json", customer: customer)
    end
  end

  def show(conn, %{"phone" => phone}) do
    case Admin.get_customer(%{"phone" => phone, "email" => nil}) do
      nil -> render(conn, "show.json", error: "No customer with that phone")
      customer -> render(conn, "show.json", customer: customer)
    end
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Admin.get_customer!(id)

    with {:ok, %Customer{} = customer} <- Admin.update_customer(customer, customer_params) do
      render(conn, "show.json", customer: customer)
    end
  end

  def update(conn, %{"customer" => customer_params}) do
    customer = Admin.get_customer(customer_params)

    with {:ok, %Customer{} = customer} <- Admin.update_customer(customer, customer_params) do
      render(conn, "show.json", customer: customer)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Admin.get_customer!(id)

    with {:ok, %Customer{}} <- Admin.delete_customer(customer) do
      send_resp(conn, :no_content, "")
    end
  end
end

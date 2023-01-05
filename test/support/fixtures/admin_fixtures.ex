defmodule PointsApi.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointsApi.Admin` context.
  """

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{
        balance: 42,
        email: "some email",
        phone: "some phone"
      })
      |> PointsApi.Admin.create_customer()

    customer
  end
end

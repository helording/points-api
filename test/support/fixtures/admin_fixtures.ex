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
        email: "s@s",
        phone: "123"
      })
      |> PointsApi.Admin.create_customer()

    customer
  end
end

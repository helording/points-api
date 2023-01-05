defmodule PointsApiWeb.OrderView do
  use PointsApiWeb, :view
  alias PointsApiWeb.OrderView
  alias PointsApiWeb.CustomerView

  def render("show.json", %{order: order}) do
    order
  end

  def render("show.json", %{error: message}) do
    %{data: message}
  end
end

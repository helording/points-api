defmodule PointsApi.Repo.Migrations.BalanceNotNull do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      modify :balance, :integer, null: false
    end
  end
end

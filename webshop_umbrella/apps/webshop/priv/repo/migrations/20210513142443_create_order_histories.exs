defmodule Webshop.Repo.Migrations.CreateOrderHistories do
  use Ecto.Migration

  def change do
    create table(:order_histories) do
      add :user_id, references(:users)
      add :order_id, :integer, null: false
      add :title, :string, null: false
      add :description, :string, null: false
      add :size, :integer, null: false
      add :color, :string, null: false
      add :price, :float, null: false

      timestamps()
    end

    create index(:order_histories, [:user_id])
  end
end

defmodule Webshop.Repo.Migrations.CreateShoppingCarts do
  use Ecto.Migration

  def change do
    create table(:shopping_carts) do
      add :user_id, references(:users)
      add :product_id, references(:products)

      timestamps()
    end

    create index(:shopping_carts, [:user_id])
    create index(:shopping_carts, [:product_id])
  end
end

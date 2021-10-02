defmodule Webshop.ShoppingCartContext.ShoppingCart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shopping_carts" do
    field :user_id, :integer
    field :product_id, :integer

    timestamps()
  end

  @doc false
  def changeset(shopping_cart, attrs) do
    shopping_cart
    |> cast(attrs, [:user_id, :product_id])
    |> validate_required([:user_id, :product_id])
  end
end

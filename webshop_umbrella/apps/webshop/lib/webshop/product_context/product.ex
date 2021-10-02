defmodule Webshop.ProductContext.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Webshop.UserContext.User

  schema "products" do
    field :color, :string, null: false
    field :description, :string, null: false
    field :price, :float, null: false
    field :size, :integer, null: false
    field :stock, :integer, null: false
    field :title, :string, null: false
    many_to_many :users, User, join_through: "shopping_carts"

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :stock, :size, :color, :price])
    |> validate_required([:title, :description, :stock, :size, :color, :price])
  end
end

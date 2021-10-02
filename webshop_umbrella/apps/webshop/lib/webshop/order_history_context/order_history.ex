defmodule Webshop.OrderHistoryContext.OrderHistory do
  use Ecto.Schema
  import Ecto.Changeset
  alias Webshop.UserContext.User

  schema "order_histories" do
    field :order_id, :integer, null: false
    field :title, :string, null: false
    field :description, :string, null: false
    field :size, :integer, null: false
    field :color, :string, null: false
    field :price, :float, null: false
    field :postcode, :integer, null: false
    field :straatnaam, :string, null: false
    field :huisnummer, :integer, null: false
    field :busnummer, :integer, null: true
    field :retour, :boolean, null: false, default: false

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(order_history, attrs) do
    order_history
    |> cast(attrs, [:user_id, :order_id, :title, :description, :size, :color, :price, :postcode, :straatnaam, :huisnummer, :busnummer, :retour])
    |> validate_required([:user_id, :order_id, :title, :description, :size, :color, :price, :postcode, :straatnaam, :huisnummer, :busnummer, :retour])
  end

  @doc false
  def addressChangeset(order_history, attrs) do
    order_history
    |> cast(attrs, [:postcode, :straatnaam, :huisnummer, :busnummer])
    |> validate_required([:postcode, :straatnaam, :huisnummer, :busnummer])
  end
end

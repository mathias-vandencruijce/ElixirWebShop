defmodule Webshop.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Webshop.ProductContext.Product
  alias Webshop.OrderHistoryContext.OrderHistory

  @acceptable_roles ["Admin", "Manager", "User"]

  schema "users" do
    field :city, :string, null: false, size: 50
    field :country, :string, null: false, size: 50
    field :email, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :house_number, :integer, null: false
    field :password, :string, null: false
    field :unhashed_password, :string, virtual: true, null: true
    field :role, :string, default: "User", null: false
    field :street, :string, null: false
    field :zip_code, :integer, null: false
    field :password_reset_token, :string, null: true
    field :password_reset_sent_at, :naive_datetime, null: true
    field :api_key, :string, null: true
    many_to_many :products, Product, join_through: "shopping_carts"
    has_many :order_histories, OrderHistory

    timestamps()
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :role, :email, :password, :country, :city, :zip_code, :street, :house_number, :password_reset_token, :password_reset_sent_at, :api_key])
    |> unique_constraint(:user, name: "users_email_index")
    |> validate_required([:first_name, :last_name, :role, :email, :password, :country, :city, :zip_code, :street, :house_number])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()

  end

  @doc false
  def userChangeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :country, :city, :zip_code, :street, :house_number])
    |> unique_constraint(:user, name: "users_email_index")
    |> validate_required([:first_name, :last_name, :email, :password, :country, :city, :zip_code, :street, :house_number])
    |> put_change(:role, "User")
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: unhashed_password}} = changeset) do
    change(changeset, password: Pbkdf2.hash_pwd_salt(unhashed_password))
  end

  defp put_password_hash(changeset), do: changeset
end

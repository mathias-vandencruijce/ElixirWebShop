defmodule Webshop.ShoppingCartContext do
  @moduledoc """
  The ShoppingCartContext context.
  """

  import Ecto.Query, warn: false
  alias Webshop.Repo

  alias Webshop.ProductContext
  alias Webshop.ShoppingCartContext
  alias Webshop.ShoppingCartContext.ShoppingCart

  @doc """
  Returns the list of shopping_carts.

  ## Examples

      iex> list_shopping_carts()
      [%ShoppingCart{}, ...]

  """
  def list_shopping_carts do
    Repo.all(ShoppingCart)
  end

  @doc """
  Gets the shopping_cart product id's from the given user.

  ## Examples

      iex> list_user_shopping_carts!(123)
      [%ShoppingCart{}, ...]

  """
  def list_user_shopping_carts(id) do
    ShoppingCart
    |> where(user_id: ^id)
    |> select([:id, :product_id])
    |> Repo.all()
  end

  @doc """
  Gets a single shopping_cart.

  Raises `Ecto.NoResultsError` if the Shopping cart does not exist.

  ## Examples

      iex> get_shopping_cart!(123)
      %ShoppingCart{}

      iex> get_shopping_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shopping_cart!(id), do: Repo.get!(ShoppingCart, id)

  def get_shopping_cart(id), do: Repo.get(ShoppingCart, id)

  @doc """
  Creates a shopping_cart.

  ## Examples

      iex> create_shopping_cart(%{field: value})
      {:ok, %ShoppingCart{}}

      iex> create_shopping_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shopping_cart(attrs \\ %{}) do
    %ShoppingCart{}
    |> ShoppingCart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shopping_cart.

  ## Examples

      iex> update_shopping_cart(shopping_cart, %{field: new_value})
      {:ok, %ShoppingCart{}}

      iex> update_shopping_cart(shopping_cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shopping_cart(%ShoppingCart{} = shopping_cart, attrs) do
    shopping_cart
    |> ShoppingCart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shopping_cart.

  ## Examples

      iex> delete_shopping_cart(shopping_cart)
      {:ok, %ShoppingCart{}}

      iex> delete_shopping_cart(shopping_cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shopping_cart(%ShoppingCart{} = shopping_cart) do
    Repo.delete(shopping_cart)
  end

  def delete_products_from_shopping_cart(product) do
    from(s in ShoppingCart, where: s.product_id == ^product.id)
    |> Repo.delete_all
    product
  end

  def get_all_cart_products(cart) do
    Enum.map(cart, fn s -> Map.replace!(ProductContext.get_product!(s.product_id), :id, s.id) end)
  end

  def get_amount_of_items_in_cart(user_id) do
    Enum.sum(Enum.map(ShoppingCartContext.list_user_shopping_carts(user_id), fn _x -> 1 end))
  end

    @doc """
    Deletes a shopping_cart.
    ## Examples

      iex> delete_shopping_cart(shopping_cart)
      {:ok, %ShoppingCart{}}

      iex> delete_shopping_cart(shopping_cart)
      {:error, %Ecto.Changeset{}}

  """
  def empty_user_shopping_cart(user_id) do
    Repo.delete_all(from s in ShoppingCart, where: s.user_id == ^user_id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shopping_cart changes.

  ## Examples

      iex> change_shopping_cart(shopping_cart)
      %Ecto.Changeset{data: %ShoppingCart{}}

  """
  def change_shopping_cart(%ShoppingCart{} = shopping_cart, attrs \\ %{}) do
    ShoppingCart.changeset(shopping_cart, attrs)
  end
end

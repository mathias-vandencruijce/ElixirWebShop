defmodule Webshop.OrderHistoryContext do
  @moduledoc """
  The OrderHistoryContext context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Webshop.Repo
  alias Webshop.ShoppingCartContext
  alias Webshop.ProductContext
  alias Webshop.OrderHistoryContext
  alias Webshop.OrderHistoryContext.OrderHistory

  @doc """
  Returns the list of order_histories.

  ## Examples

      iex> list_order_histories()
      [%OrderHistory{}, ...]

  """
  def list_order_histories do
    Repo.all(OrderHistory)
  end

  @doc """
  Returns the list of order_histories for a given order_id for a user with user_id.

  ## Examples

      iex> list_order_histories()
      [%OrderHistory{}, ...]

  """
  def list_order_histories_for_order(user_id, order_id) do
    OrderHistory
    |> where(user_id: ^user_id)
    |> where(order_id: ^order_id)
    |> Repo.all()
  end

  def list_order_histories_for_user(user_id) do
    query = from o in OrderHistory,
            where: o.user_id == ^user_id,
            select: [o.order_id, o.inserted_at, sum(o.price)],
            group_by: [o.order_id, o.inserted_at],
            order_by: o.inserted_at

    Repo.all(query)
  end

  def list_order_histories_for_user_and_order_id() do
    query = from o in OrderHistory,
            select: [o.user_id, o.order_id, o.inserted_at, sum(o.price)],
            group_by: [o.user_id, o.order_id, o.inserted_at],
            order_by: o.inserted_at

    Repo.all(query)
  end

  def list_product_order_histories_for_user(user_id) do
    OrderHistory
    |> where(user_id: ^user_id)
    |> order_by(:inserted_at)
    |> Repo.all()
  end

  def get_highest_order_id(user_id) do
    query = from o in OrderHistory,
            where: o.user_id == ^user_id,
            select: max(o.order_id)
    result = Repo.all(query)
    if result == [nil] do
      0
    else
      Enum.at(result, 0)
    end
  end

  def set_all_cart_items(user_id, order_id, address) do
    product_ids = ShoppingCartContext.list_user_shopping_carts(user_id)
    if product_ids != [] do
      shopping_cart_products = Enum.map(product_ids, fn s -> Map.replace!(ProductContext.get_product!(s.product_id), :id, s.id) end)
      Enum.map(shopping_cart_products, fn p -> OrderHistoryContext.create_order_history(%{user_id: user_id ,order_id: order_id, title: p.title, description: p.description, size: p.size, color: p.color, price: p.price, postcode: address["postcode"], straatnaam: address["straatnaam"], huisnummer: address["huisnummer"], busnummer: address["busnummer"]}) end)
      ShoppingCartContext.empty_user_shopping_cart(user_id)
      true
    else
      false
    end
  end

  @doc """
  Gets a single order_history.

  Raises `Ecto.NoResultsError` if the Order history does not exist.

  ## Examples

      iex> get_order_history!(123)
      %OrderHistory{}

      iex> get_order_history!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order_history!(id), do: Repo.get!(OrderHistory, id)

  @doc """
  Creates a order_history.

  ## Examples

      iex> create_order_history(%{field: value})
      {:ok, %OrderHistory{}}

      iex> create_order_history(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_history(attrs \\ %{}) do
    %OrderHistory{}
    |> OrderHistory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_history.

  ## Examples

      iex> update_order_history(order_history, %{field: new_value})
      {:ok, %OrderHistory{}}

      iex> update_order_history(order_history, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_history(%OrderHistory{} = order_history, attrs) do
    order_history
    |> OrderHistory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order_history.

  ## Examples

      iex> delete_order_history(order_history)
      {:ok, %OrderHistory{}}

      iex> delete_order_history(order_history)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_history(%OrderHistory{} = order_history) do
    Repo.delete(order_history)
  end

  def delete_user_history(user) do
    from(o in OrderHistory, where: o.user_id == ^user.id)
    |> Repo.delete_all
    user
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order_history changes.

  ## Examples

      iex> change_order_history(order_history)
      %Ecto.Changeset{data: %OrderHistory{}}

  """
  def change_order_history(%OrderHistory{} = order_history, attrs \\ %{}) do
    OrderHistory.changeset(order_history, attrs)
  end

  def check_address(address \\ %{}) do
    %OrderHistory{}
    |> OrderHistory.addressChangeset(address)
  end

  def change_address(order_history, attrs \\ %{}) do
    OrderHistory.addressChangeset(order_history, attrs)
  end

  def set_retour(id) do
    order = get_order_history!(id)
    attrs = %{
      "retour" => true
    }

    order
    |> OrderHistory.changeset(attrs)
    |> Repo.update!()
  end
end

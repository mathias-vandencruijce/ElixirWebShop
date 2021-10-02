defmodule Webshop.ProductContext do
  @moduledoc """
  The ProductContext context.
  """

  import Ecto.Query, warn: false
  alias Webshop.Repo
  alias Webshop.ProductContext
  alias Webshop.ProductContext.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  def get_product(id), do: Repo.get(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def search(attrs) do
    title = get_in(attrs, ["title"])
    size = if get_in(attrs, ["size"]) == "", do: -1, else: elem(Integer.parse(get_in(attrs, ["size"])), 0)
    color = get_in(attrs, ["color"])
    minPrice = if get_in(attrs, ["minPrice"]) == "", do: -1.0, else: elem(Float.parse(get_in(attrs, ["minPrice"])), 0)
    maxPrice = if get_in(attrs, ["maxPrice"]) == "", do: -1.0, else: elem(Float.parse(get_in(attrs, ["maxPrice"])), 0)

    Repo.all(
      from p in Product,
      where: ilike(p.title, ^"%#{title}%") and (^size == -1 or p.size == ^size) and ilike(p.color, ^"%#{color}%") and (^minPrice == -1.0 or p.price >= ^minPrice) and (^maxPrice == -1.0 or p.price <= ^maxPrice)
    )
  end

  def insert_csv_into_database(file) do
    File.stream!(file.path)
    |> Stream.drop(1)
    |> CSV.decode
    |> Enum.each(fn(product) ->
      case product do
        {:ok, product} ->
          create_product(%{title: Enum.at(product, 0), description: Enum.at(product, 1), stock: Enum.at(product, 2), size: Enum.at(product, 3), color: Enum.at(product, 4), price: Enum.at(product, 5)})
        {:error, _error} -> nil
      end
    end)
  end
end

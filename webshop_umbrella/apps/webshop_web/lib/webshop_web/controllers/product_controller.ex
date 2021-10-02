defmodule WebshopWeb.ProductController do
  use WebshopWeb, :controller

  alias Webshop.ProductContext
  alias Webshop.ProductContext.Product
  alias Webshop.ShoppingCartContext
  alias Webshop.ShoppingCartContext.ShoppingCart

  def throwCouldNotFindProduct(conn, destination) do
    conn
    |> put_flash(:error, "Could not find product.")
    |> redirect(to: destination)
  end

  def index(conn, _params) do
    render(conn, "index.html", products: ProductContext.list_products())
  end

  def shop(conn, _params) do
      render(conn, "shop.html", products: ProductContext.list_products(), changeset: ShoppingCartContext.change_shopping_cart(%ShoppingCart{}))
  end

  def search(conn, params) do
    render(conn, "shop.html", products: ProductContext.search(params), changeset: ShoppingCartContext.change_shopping_cart(%ShoppingCart{}))
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: ProductContext.change_product(%Product{}))
  end

  def create(conn, %{"product" => product_params}) do
    case ProductContext.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
      product_id ->
        case ProductContext.get_product(elem(product_id, 0)) do
          nil -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
          product -> render(conn, "show.html", product: product)
        end
    end
  end

  def edit(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
      product_id ->
        case ProductContext.get_product(elem(product_id, 0)) do
          nil -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
          product ->
            render(conn, "edit.html", product: product, changeset: ProductContext.change_product(product))
        end
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
      product_id ->
        case ProductContext.get_product(elem(product_id, 0)) do
          nil -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
          product ->
            case ProductContext.update_product(product, product_params) do
              {:ok, product} ->
                conn
                |> put_flash(:info, "Product updated successfully.")
                |> redirect(to: Routes.product_path(conn, :show, product))

              {:error, %Ecto.Changeset{} = changeset} -> render(conn, "edit.html", product: product, changeset: changeset)
            end
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
      product_id ->
        case ProductContext.get_product(elem(product_id, 0)) do
          nil -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :index))
          product ->
            product
            |> ShoppingCartContext.delete_products_from_shopping_cart
            |> ProductContext.delete_product

            conn
            |> put_flash(:info, "Product deleted successfully.")
            |> redirect(to: Routes.product_path(conn, :index))
        end
    end
  end

  def import(conn, _params) do
    render(conn, "bulk_import.html")
  end

  def bulk_import(conn, %{"file" => file}) do

    ProductContext.insert_csv_into_database(file)

    conn
    |> put_flash(:info, "Products added successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end

  def bulk_import(conn, _) do
    conn
    |> put_flash(:error, "Please upload a file using the upload zone below.")
    |> redirect(to: Routes.product_path(conn, :import))
  end

  def api_index(conn, _) do
    render(conn, "index.json", products: ProductContext.list_products())
  end

  def api_show(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error -> render(conn, "error.json", error: "Product does not exist.")
      id ->
        case ProductContext.get_product(elem(id, 0)) do
          nil -> render(conn, "error.json", error: "Product does not exist.")
          product -> render(conn, "show.json", product: product)
        end
    end
  end
end

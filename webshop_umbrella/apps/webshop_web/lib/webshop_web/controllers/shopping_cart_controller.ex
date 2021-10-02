defmodule WebshopWeb.ShoppingCartController do
  use WebshopWeb, :controller

  alias Webshop.ShoppingCartContext
  alias Webshop.ProductContext

  def throwCouldNotFindProduct(conn, destination) do
    conn
    |> put_flash(:error, "Could not find product.")
    |> redirect(to: destination)
  end

  def index(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :user).id
    user_shopping_cart = ShoppingCartContext.list_user_shopping_carts(user_id)
    shopping_cart_products = ShoppingCartContext.get_all_cart_products(user_shopping_cart)

    conn = delete_session(conn, :amountOfShopItems)
    conn = put_session(conn, :amountOfShopItems, ShoppingCartContext.get_amount_of_items_in_cart(user_id))
    render(conn, "index.html", products: shopping_cart_products)
  end

  def create(conn, %{"shopping_cart" => %{"product_id" => p_id}}) do
    case Integer.parse(p_id) do
      :error -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :shop))
      product_id ->
        product_id = elem(product_id, 0)
        if ProductContext.get_product(product_id) != nil do
          entry = %{
            product_id: product_id,
            user_id: Plug.Conn.get_session(conn, :user).id
          }

          case ShoppingCartContext.create_shopping_cart(entry) do
            {:ok, _} ->
              conn = delete_session(conn, :amountOfShopItems)
              conn = put_session(conn, :amountOfShopItems, ShoppingCartContext.get_amount_of_items_in_cart(Plug.Conn.get_session(conn, :user).id))
              conn
              |> put_flash(:info, "Successfully added product to shopping cart.")
              |> redirect(to: Routes.shopping_cart_path(conn, :index))

            {:error, _} -> Routes.product_path(conn, :shop)
          end
        else
          throwCouldNotFindProduct(conn, Routes.product_path(conn, :shop))
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :shop))
      id ->
        id = elem(id, 0)
        case ShoppingCartContext.get_shopping_cart(id) do
          nil -> throwCouldNotFindProduct(conn, Routes.product_path(conn, :shop))
          product ->
            ShoppingCartContext.delete_shopping_cart(product)
            conn = delete_session(conn, :amountOfShopItems)
            conn = put_session(conn, :amountOfShopItems, 0)

            conn
            |> put_flash(:info, "Successfully removed product from shopping cart.")
            |> redirect(to: Routes.shopping_cart_path(conn, :index))
        end
      end
  end
end

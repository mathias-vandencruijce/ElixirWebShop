defmodule WebshopWeb.ShoppingCartControllerTest do
  use WebshopWeb.ConnCase

  alias Webshop.ShoppingCartContext

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:shopping_cart) do
    {:ok, shopping_cart} = ShoppingCartContext.create_shopping_cart(@create_attrs)
    shopping_cart
  end

  describe "index" do
    test "lists all shopping_carts", %{conn: conn} do
      conn = get(conn, Routes.shopping_cart_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Shopping carts"
    end
  end

  describe "new shopping_cart" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.shopping_cart_path(conn, :new))
      assert html_response(conn, 200) =~ "New Shopping cart"
    end
  end

  describe "create shopping_cart" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.shopping_cart_path(conn, :create), shopping_cart: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.shopping_cart_path(conn, :show, id)

      conn = get(conn, Routes.shopping_cart_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Shopping cart"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.shopping_cart_path(conn, :create), shopping_cart: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Shopping cart"
    end
  end

  describe "edit shopping_cart" do
    setup [:create_shopping_cart]

    test "renders form for editing chosen shopping_cart", %{conn: conn, shopping_cart: shopping_cart} do
      conn = get(conn, Routes.shopping_cart_path(conn, :edit, shopping_cart))
      assert html_response(conn, 200) =~ "Edit Shopping cart"
    end
  end

  describe "update shopping_cart" do
    setup [:create_shopping_cart]

    test "redirects when data is valid", %{conn: conn, shopping_cart: shopping_cart} do
      conn = put(conn, Routes.shopping_cart_path(conn, :update, shopping_cart), shopping_cart: @update_attrs)
      assert redirected_to(conn) == Routes.shopping_cart_path(conn, :show, shopping_cart)

      conn = get(conn, Routes.shopping_cart_path(conn, :show, shopping_cart))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, shopping_cart: shopping_cart} do
      conn = put(conn, Routes.shopping_cart_path(conn, :update, shopping_cart), shopping_cart: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Shopping cart"
    end
  end

  describe "delete shopping_cart" do
    setup [:create_shopping_cart]

    test "deletes chosen shopping_cart", %{conn: conn, shopping_cart: shopping_cart} do
      conn = delete(conn, Routes.shopping_cart_path(conn, :delete, shopping_cart))
      assert redirected_to(conn) == Routes.shopping_cart_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.shopping_cart_path(conn, :show, shopping_cart))
      end
    end
  end

  defp create_shopping_cart(_) do
    shopping_cart = fixture(:shopping_cart)
    %{shopping_cart: shopping_cart}
  end
end

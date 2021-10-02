defmodule Webshop.ShoppingCartContextTest do
  use Webshop.DataCase

  alias Webshop.ShoppingCartContext

  describe "shopping_carts" do
    alias Webshop.ShoppingCartContext.ShoppingCart

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def shopping_cart_fixture(attrs \\ %{}) do
      {:ok, shopping_cart} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ShoppingCartContext.create_shopping_cart()

      shopping_cart
    end

    test "list_shopping_carts/0 returns all shopping_carts" do
      shopping_cart = shopping_cart_fixture()
      assert ShoppingCartContext.list_shopping_carts() == [shopping_cart]
    end

    test "get_shopping_cart!/1 returns the shopping_cart with given id" do
      shopping_cart = shopping_cart_fixture()
      assert ShoppingCartContext.get_shopping_cart!(shopping_cart.id) == shopping_cart
    end

    test "create_shopping_cart/1 with valid data creates a shopping_cart" do
      assert {:ok, %ShoppingCart{} = shopping_cart} = ShoppingCartContext.create_shopping_cart(@valid_attrs)
    end

    test "create_shopping_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShoppingCartContext.create_shopping_cart(@invalid_attrs)
    end

    test "update_shopping_cart/2 with valid data updates the shopping_cart" do
      shopping_cart = shopping_cart_fixture()
      assert {:ok, %ShoppingCart{} = shopping_cart} = ShoppingCartContext.update_shopping_cart(shopping_cart, @update_attrs)
    end

    test "update_shopping_cart/2 with invalid data returns error changeset" do
      shopping_cart = shopping_cart_fixture()
      assert {:error, %Ecto.Changeset{}} = ShoppingCartContext.update_shopping_cart(shopping_cart, @invalid_attrs)
      assert shopping_cart == ShoppingCartContext.get_shopping_cart!(shopping_cart.id)
    end

    test "delete_shopping_cart/1 deletes the shopping_cart" do
      shopping_cart = shopping_cart_fixture()
      assert {:ok, %ShoppingCart{}} = ShoppingCartContext.delete_shopping_cart(shopping_cart)
      assert_raise Ecto.NoResultsError, fn -> ShoppingCartContext.get_shopping_cart!(shopping_cart.id) end
    end

    test "change_shopping_cart/1 returns a shopping_cart changeset" do
      shopping_cart = shopping_cart_fixture()
      assert %Ecto.Changeset{} = ShoppingCartContext.change_shopping_cart(shopping_cart)
    end
  end
end

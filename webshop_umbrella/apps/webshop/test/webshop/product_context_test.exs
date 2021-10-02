defmodule Webshop.ProductContextTest do
  use Webshop.DataCase

  alias Webshop.ProductContext

  describe "products" do
    alias Webshop.ProductContext.Product

    @valid_attrs %{color: "some color", description: "some description", price: 120.5, size: 120.5, stock: 42, title: "some title"}
    @update_attrs %{color: "some updated color", description: "some updated description", price: 456.7, size: 456.7, stock: 43, title: "some updated title"}
    @invalid_attrs %{color: nil, description: nil, price: nil, size: nil, stock: nil, title: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProductContext.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert ProductContext.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert ProductContext.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = ProductContext.create_product(@valid_attrs)
      assert product.color == "some color"
      assert product.description == "some description"
      assert product.price == 120.5
      assert product.size == 120.5
      assert product.stock == 42
      assert product.title == "some title"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProductContext.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = ProductContext.update_product(product, @update_attrs)
      assert product.color == "some updated color"
      assert product.description == "some updated description"
      assert product.price == 456.7
      assert product.size == 456.7
      assert product.stock == 43
      assert product.title == "some updated title"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = ProductContext.update_product(product, @invalid_attrs)
      assert product == ProductContext.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = ProductContext.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> ProductContext.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = ProductContext.change_product(product)
    end
  end
end

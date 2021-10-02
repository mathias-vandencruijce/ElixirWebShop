defmodule Webshop.OrderHistoryContextTest do
  use Webshop.DataCase

  alias Webshop.OrderHistoryContext

  describe "order_histories" do
    alias Webshop.OrderHistoryContext.OrderHistory

    @valid_attrs %{color: "some color", description: "some description", order_id: 42, price: 120.5, size: 42, title: "some title", user_id: "some user_id"}
    @update_attrs %{color: "some updated color", description: "some updated description", order_id: 43, price: 456.7, size: 43, title: "some updated title", user_id: "some updated user_id"}
    @invalid_attrs %{color: nil, description: nil, order_id: nil, price: nil, size: nil, title: nil, user_id: nil}

    def order_history_fixture(attrs \\ %{}) do
      {:ok, order_history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> OrderHistoryContext.create_order_history()

      order_history
    end

    test "list_order_histories/0 returns all order_histories" do
      order_history = order_history_fixture()
      assert OrderHistoryContext.list_order_histories() == [order_history]
    end

    test "get_order_history!/1 returns the order_history with given id" do
      order_history = order_history_fixture()
      assert OrderHistoryContext.get_order_history!(order_history.id) == order_history
    end

    test "create_order_history/1 with valid data creates a order_history" do
      assert {:ok, %OrderHistory{} = order_history} = OrderHistoryContext.create_order_history(@valid_attrs)
      assert order_history.color == "some color"
      assert order_history.description == "some description"
      assert order_history.order_id == 42
      assert order_history.price == 120.5
      assert order_history.size == 42
      assert order_history.title == "some title"
      assert order_history.user_id == "some user_id"
    end

    test "create_order_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrderHistoryContext.create_order_history(@invalid_attrs)
    end

    test "update_order_history/2 with valid data updates the order_history" do
      order_history = order_history_fixture()
      assert {:ok, %OrderHistory{} = order_history} = OrderHistoryContext.update_order_history(order_history, @update_attrs)
      assert order_history.color == "some updated color"
      assert order_history.description == "some updated description"
      assert order_history.order_id == 43
      assert order_history.price == 456.7
      assert order_history.size == 43
      assert order_history.title == "some updated title"
      assert order_history.user_id == "some updated user_id"
    end

    test "update_order_history/2 with invalid data returns error changeset" do
      order_history = order_history_fixture()
      assert {:error, %Ecto.Changeset{}} = OrderHistoryContext.update_order_history(order_history, @invalid_attrs)
      assert order_history == OrderHistoryContext.get_order_history!(order_history.id)
    end

    test "delete_order_history/1 deletes the order_history" do
      order_history = order_history_fixture()
      assert {:ok, %OrderHistory{}} = OrderHistoryContext.delete_order_history(order_history)
      assert_raise Ecto.NoResultsError, fn -> OrderHistoryContext.get_order_history!(order_history.id) end
    end

    test "change_order_history/1 returns a order_history changeset" do
      order_history = order_history_fixture()
      assert %Ecto.Changeset{} = OrderHistoryContext.change_order_history(order_history)
    end
  end
end

defmodule WebshopWeb.OrderHistoryControllerTest do
  use WebshopWeb.ConnCase

  alias Webshop.OrderHistoryContext

  @create_attrs %{color: "some color", description: "some description", order_id: 42, price: 120.5, size: 42, title: "some title", user_id: "some user_id"}
  @update_attrs %{color: "some updated color", description: "some updated description", order_id: 43, price: 456.7, size: 43, title: "some updated title", user_id: "some updated user_id"}
  @invalid_attrs %{color: nil, description: nil, order_id: nil, price: nil, size: nil, title: nil, user_id: nil}

  def fixture(:order_history) do
    {:ok, order_history} = OrderHistoryContext.create_order_history(@create_attrs)
    order_history
  end

  describe "index" do
    test "lists all order_histories", %{conn: conn} do
      conn = get(conn, Routes.order_history_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Order histories"
    end
  end

  describe "new order_history" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.order_history_path(conn, :new))
      assert html_response(conn, 200) =~ "New Order history"
    end
  end

  describe "create order_history" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.order_history_path(conn, :create), order_history: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.order_history_path(conn, :show, id)

      conn = get(conn, Routes.order_history_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Order history"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.order_history_path(conn, :create), order_history: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Order history"
    end
  end

  describe "edit order_history" do
    setup [:create_order_history]

    test "renders form for editing chosen order_history", %{conn: conn, order_history: order_history} do
      conn = get(conn, Routes.order_history_path(conn, :edit, order_history))
      assert html_response(conn, 200) =~ "Edit Order history"
    end
  end

  describe "update order_history" do
    setup [:create_order_history]

    test "redirects when data is valid", %{conn: conn, order_history: order_history} do
      conn = put(conn, Routes.order_history_path(conn, :update, order_history), order_history: @update_attrs)
      assert redirected_to(conn) == Routes.order_history_path(conn, :show, order_history)

      conn = get(conn, Routes.order_history_path(conn, :show, order_history))
      assert html_response(conn, 200) =~ "some updated color"
    end

    test "renders errors when data is invalid", %{conn: conn, order_history: order_history} do
      conn = put(conn, Routes.order_history_path(conn, :update, order_history), order_history: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Order history"
    end
  end

  describe "delete order_history" do
    setup [:create_order_history]

    test "deletes chosen order_history", %{conn: conn, order_history: order_history} do
      conn = delete(conn, Routes.order_history_path(conn, :delete, order_history))
      assert redirected_to(conn) == Routes.order_history_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.order_history_path(conn, :show, order_history))
      end
    end
  end

  defp create_order_history(_) do
    order_history = fixture(:order_history)
    %{order_history: order_history}
  end
end

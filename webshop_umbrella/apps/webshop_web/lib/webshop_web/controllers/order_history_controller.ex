defmodule WebshopWeb.OrderHistoryController do
  use WebshopWeb, :controller

  alias Webshop.OrderHistoryContext.OrderHistory
  alias Webshop.OrderHistoryContext
  alias Webshop.UserContext
  alias Webshop.Email
  alias Webshop.Mailer

  def throwCouldNotFindOrder(conn, destination) do
    conn
    |> put_flash(:error, "Could not find order.")
    |> redirect(to: destination)
  end

  def index(conn, _params) do
    render(conn, "index.html", userOrders: OrderHistoryContext.list_order_histories_for_user_and_order_id())
  end

  def order(conn, %{"order_history" => address}) do
    user_id = Plug.Conn.get_session(conn, :user).id
    order_id = OrderHistoryContext.get_highest_order_id(user_id) + 1
    add = OrderHistoryContext.check_address(address)

    if add.valid? do
        if OrderHistoryContext.set_all_cart_items(user_id, order_id, address) do
          conn = put_session(conn, :amountOfShopItems, 0)
          conn
          |> Email.order_confirmation_email(Plug.Conn.get_session(conn, :user), OrderHistoryContext.list_order_histories_for_order(user_id, order_id))
          |> Mailer.deliver_now

          redirect(conn, to: "/orderConfirmation/" <> Integer.to_string(order_id))
        else
          conn
          |> put_flash(:error, "Empty shopping cart!")
          |> redirect(to: Routes.shopping_cart_path(conn, :index))
        end
    else
      conn
      |> put_flash(:error, "Address is not filled in right as required")
      |> redirect(to: Routes.order_history_path(conn, :address))
    end
  end

  def address(conn, _) do
    render(conn, "address.html", changeset: OrderHistoryContext.change_address(%OrderHistory{}))
  end

  def orders(conn, _) do
    render(conn, "order_overview.html", orders: OrderHistoryContext.list_order_histories_for_user(Plug.Conn.get_session(conn, :user).id))
  end

  def retour(conn, %{"id" => id}) do
    order = OrderHistoryContext.get_order_history!(id)

    require IEx;
    IEx.pry()
    if order != nil && order.retour == false && NaiveDateTime.add(order.inserted_at, 300, :second) >= NaiveDateTime.utc_now() do
      OrderHistoryContext.set_retour(id)
      conn
      |> put_flash(:info, "Succesful request")
      |> redirect(to: Routes.order_history_path(conn, :orders))
    else 
      conn
      |> put_flash(:error, "Not elligeble for retour, either already returned or too early")
      |> redirect(to: Routes.order_history_path(conn, :orders))
    end
  end

  def orderOverview(conn, %{"id" => o_id}) do
    case Integer.parse(o_id) do
      :error -> throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :orders))
      order_id ->
        order_id = elem(order_id, 0)
        if OrderHistoryContext.list_order_histories_for_order(Plug.Conn.get_session(conn, :user).id, order_id) != [] do
          render(conn, "order_confirmation.html", order_histories: OrderHistoryContext.list_order_histories_for_order(Plug.Conn.get_session(conn, :user).id, order_id), type: "userHistory")
        else
          throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :orders))
        end
    end
  end

  def orderOverviewForUserAndOrderId(conn, %{"order_id" => o_id, "user_id" => u_id}) do
    case Integer.parse(u_id) do
      :error -> throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :index))
      user_id ->
        user_id = elem(user_id, 0)
        case Integer.parse(o_id) do
          :error -> throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :index))
          order_id ->
            order_id = elem(order_id, 0)
            if UserContext.get_user(user_id) == nil do
              throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :index))
            else
              case OrderHistoryContext.list_order_histories_for_order(user_id, order_id) do
                [] -> throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :index))
                order_histories -> render(conn, "order_confirmation.html", order_histories: order_histories, type: "adminHistory")
              end
            end
        end
    end
  end

  def orderConfirmation(conn, %{"id" => o_id}) do
    case Integer.parse(o_id) do
      :error -> throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :orders))
      order_id ->
        order_id = elem(order_id, 0)
        case OrderHistoryContext.list_order_histories_for_order(Plug.Conn.get_session(conn, :user).id, order_id) do
          [] -> throwCouldNotFindOrder(conn, Routes.order_history_path(conn, :orders))
          order_histories -> render(conn, "order_confirmation.html", order_histories: order_histories, type: "confirmation")
        end
    end
  end

  def api_show_user(conn, %{"id" => id}) do
    if Plug.Conn.get_req_header(conn, "webshop-api-key") != [] do
      if UserContext.check_if_valid_api_key(Enum.at(Plug.Conn.get_req_header(conn, "webshop-api-key"), 0)) do
        case Integer.parse(id) do
          :error -> render(conn, "error.json", error: "User does not exist.")
          id ->
            id = elem(id, 0)
            if UserContext.get_user(id) == nil do
              render(conn, "error.json", error: "User does not exist.")
            else
              render(conn, "index.json", order_histories: OrderHistoryContext.list_product_order_histories_for_user(id))
            end
        end
      else
        render(conn, "error.json", error: "Invaild API Key given.")
      end
    else
      render(conn, "error.json", error: "No API Key given.")
    end
  end
end

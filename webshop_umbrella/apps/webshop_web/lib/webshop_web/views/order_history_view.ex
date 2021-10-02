defmodule WebshopWeb.OrderHistoryView do
  use WebshopWeb, :view
  alias WebshopWeb.OrderHistoryView

  def render("index.json", %{order_histories: order_histories}) do
    render_many(order_histories, OrderHistoryView, "order_history.json")
  end

  def render("order_history.json", %{order_history: order_history}) do
    %{order_id: order_history.order_id, title: order_history.title, color: order_history.color, description: order_history.description, price: order_history.price, size: order_history.size, orderd_at: order_history.inserted_at}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end

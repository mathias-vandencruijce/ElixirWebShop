defmodule WebshopWeb.ProductView do
  use WebshopWeb, :view
  alias WebshopWeb.ProductView

  def current_user(conn) do
    Plug.Conn.get_session(conn, :user)
  end

  def render("index.json", %{products: products}) do
    render_many(products, ProductView, "product.json")
  end

  def render("show.json", %{product: product}) do
    render_one(product, ProductView, "product.json")
  end

  def render("product.json", %{product: product}) do
    %{id: product.id, color: product.color, description: product.description, price: product.price, size: product.size, title: product.title}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end

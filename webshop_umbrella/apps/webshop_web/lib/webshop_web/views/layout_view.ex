defmodule WebshopWeb.LayoutView do
  use WebshopWeb, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :user)
  end

  def amount_of_shop_items(conn) do
    Plug.Conn.get_session(conn, :amountOfShopItems)
  end

  def new_locale(conn, locale, language_title) do
    "<a href=\"#{Routes.page_path(conn, :index, locale: locale)}\" class=\"dropdown-item\">#{language_title}</a>"
    |> raw
  end
end

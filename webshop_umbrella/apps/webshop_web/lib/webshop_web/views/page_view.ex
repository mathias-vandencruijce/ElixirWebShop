defmodule WebshopWeb.PageView do
  use WebshopWeb, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :user)
  end
end

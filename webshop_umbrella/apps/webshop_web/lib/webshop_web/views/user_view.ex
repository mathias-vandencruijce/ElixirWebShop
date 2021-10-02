defmodule WebshopWeb.UserView do
  use WebshopWeb, :view
  alias WebshopWeb.UserView

  def current_user(conn) do
    Plug.Conn.get_session(conn, :user)
  end

  def render("index.json", %{users: users}) do
   render_many(users, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, city: user.city, country: user.country, email: user.email, first_name: user.first_name, last_name: user.last_name, house_number: user.house_number, role: user.role, street: user.street, zip_code: user.zip_code}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end

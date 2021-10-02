defmodule WebshopWeb.SessionController do
  use WebshopWeb, :controller

  alias WebshopWeb.Guardian
  alias Webshop.UserContext
  alias Webshop.UserContext.User
  alias Webshop.ShoppingCartContext

  def index(conn, _) do
    changeset = UserContext.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: Routes.page_path(conn, :index))
    else
      render(conn, "login.html", changeset: changeset, action: Routes.session_path(conn, :login), notVerified: false)
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    UserContext.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn = clear_session(conn)

    conn
    |> put_flash(:info, "See you next time!")
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.session_path(conn, :index))
  end

  defp login_reply({:ok, user}, conn) do
    if user.password_reset_token == nil do
      conn = put_session(conn, :user, user)
      conn = put_session(conn, :amountOfShopItems, Enum.sum(Enum.map(ShoppingCartContext.list_user_shopping_carts(user.id), fn _x -> 1 end)))

      conn
      |> put_flash(:info, "Welcome back!")
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn = put_session(conn, :old_token, user.password_reset_token)
      render(conn, "login.html", changeset: UserContext.change_user(%User{}), action: Routes.session_path(conn, :login), notVerified: true)
    end
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> index(%{})
  end
end

defmodule Webshop.Email do
  use Bamboo.Phoenix, view: WebshopWeb.EmailView
  import Bamboo.Email

  def verification_email(user, conn) do
    new_email()
    |> from("alexandre2013@hotmail.be")
    |> to(user.email)
    |> subject("Webshop account")
    |> assign(:conn, conn)
    |> assign(:verification_link, "http://localhost:4000/verify?token=" <> user.password_reset_token)
    |> render("registration_confirmation.html")
  end

  def order_confirmation_email(conn, user, products) do
    new_email()
    |> from("alexandre2013@hotmail.be")
    |> to(user.email)
    |> subject("Webshop order")
    |> assign(:conn, conn)
    |> assign(:order_histories, products)
    |> render("order_confirmation.html")
  end
end

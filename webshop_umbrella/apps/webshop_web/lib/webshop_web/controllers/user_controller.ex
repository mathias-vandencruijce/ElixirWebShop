defmodule WebshopWeb.UserController do
  use WebshopWeb, :controller

  alias Webshop.Email
  alias Webshop.Mailer
  alias Webshop.UserContext
  alias Webshop.UserContext.User
  alias Webshop.OrderHistoryContext

  def throwCouldNotFindUser(conn, destination) do
    conn
    |> put_flash(:error, "Could not find user.")
    |> redirect(to: destination)
  end

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = UserContext.change_user(%User{})

    render(conn, "new.html",
      changeset: changeset,
      errors: nil,
      acceptable_roles: UserContext.get_acceptable_roles()
    )
  end

  def create(conn, %{"user" => user_params}) do
    case UserContext.create_user_by_admin(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          acceptable_roles: UserContext.get_acceptable_roles()
        )
    end
  end

  def show(conn, %{"id" => id}) do
   case Integer.parse(id) do
      :error -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
      user_id ->
        case UserContext.get_user(elem(user_id, 0)) do
          nil -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
          user -> render(conn, "show.html", user: user)
        end
    end
  end

  def edit(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
      user_id ->
        case UserContext.get_user(elem(user_id, 0)) do
          nil -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
          user ->
            render(conn, "edit.html", user: user, changeset: UserContext.change_user(user), acceptable_roles: UserContext.get_acceptable_roles())
        end
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
      user_id ->
        case UserContext.get_user(elem(user_id, 0)) do
          nil -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
          user ->
            case UserContext.update_user(user, user_params) do
              {:ok, user} ->
                conn
                |> put_flash(:info, "Product updated successfully.")
                |> redirect(to: Routes.user_path(conn, :show, user))

              {:error, %Ecto.Changeset{} = changeset} -> render(conn, "edit.html", user: user, changeset: changeset, acceptable_roles: UserContext.get_acceptable_roles())
            end
        end
    end
  end

  def delete(conn, %{"id" => id}) do
      case Integer.parse(id) do
        :error -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
        user_id ->
          case UserContext.get_user(elem(user_id, 0)) do
            nil -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
            user ->
              user
              |> OrderHistoryContext.delete_user_history
              |> UserContext.delete_user

              conn
              |> put_flash(:info, "User deleted successfully.")
              |> redirect(to: Routes.user_path(conn, :index))
          end
      end
  end

  def register(conn, _params) do
    users = UserContext.list_users()
    changeset = UserContext.change_user(%User{})
    render(conn, "register.html", changeset: changeset, users: users, acceptable_roles: UserContext.get_acceptable_roles())
  end

  def signUp(conn, %{"user" => user_params}) do
    case UserContext.create_user(user_params) do
      {:ok, user} ->
        user
        |> UserContext.set_token_on_user()
        |> Email.verification_email(conn)
        |> Mailer.deliver_now

        conn
        |> put_flash(:info, "Successfully signed up, please verify your account.")
        |> redirect(to: Routes.session_path(conn, :login))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html",
          changeset: changeset,
          acceptable_roles: UserContext.get_acceptable_roles()
        )
    end
  end

  def settings(conn, _params) do
    user = Plug.Conn.get_session(conn, :user)
    changeset = UserContext.change_user(user)

    render(conn, "settings.html",
      user: user,
      changeset: changeset,
      acceptable_roles: UserContext.get_acceptable_roles()
    )
  end

  def saveSettings(conn, %{"user" => user_params}) do
    user = Plug.Conn.get_session(conn, :user)
    if user.role == "Admin" do
      handle_update(UserContext.update_user_by_admin(user, user_params), conn, user)
    else
      handle_update(UserContext.update_user(user, user_params), conn, user)
    end
  end

  defp handle_update(result, conn, user) do
    case result do
      {:ok, user} ->
        conn
        |> put_session(:user, user)
        |> put_flash(:info, "Succesfully updated your settings.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "settings.html",
          user: user,
          changeset: changeset,
          acceptable_roles: UserContext.get_acceptable_roles()
        )
      Plug.Conn.put_session(conn, :user, user)
    end
  end

  def verify(conn, %{"token" => token}) do
    user = UserContext.get_user_from_token(token)

    if user do
      if NaiveDateTime.add(user.password_reset_sent_at, 86_400, :second) >= NaiveDateTime.utc_now() do
        UserContext.clear_token_on_user(user)

        conn
        |> put_flash(:info, "Successfully verified your account.")
        |> redirect(to: Routes.session_path(conn, :login))
      else
        resendConfirmationEmail(conn, token)
        render(conn, "error.html", expiredToken: token)
      end
    else
      render(conn, "error.html", expiredToken: nil)
    end
  end

  def manual_verify(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
      id ->
        id = elem(id, 0)
        case UserContext.get_user(id) do
          nil -> throwCouldNotFindUser(conn, Routes.user_path(conn, :index))
          user ->
            if user do
                UserContext.clear_token_on_user(user)

                conn
                |> put_flash(:info, "Successfully verified that account.")
            end
            conn
            |> redirect(to: Routes.user_path(conn, :index))
        end
    end
  end

  defp resendConfirmationEmail(conn, token) do
    user = UserContext.get_user_from_token(token)

    if user do
      user
        |> UserContext.set_token_on_user()
        |> Email.verification_email(conn)
        |> Mailer.deliver_now

      conn
      |> put_flash(:info, "A new confirmation email has been sent, please check your email.")
      |> redirect(to: Routes.session_path(conn, :login))
    else
      render(conn, "error.html", expiredToken: nil)
    end
  end

  def regenerate_token(conn, %{"token" => token}) do
    resendConfirmationEmail(conn, token)
  end

  def resend_email(conn, _) do
    resendConfirmationEmail(conn, Plug.Conn.get_session(conn, :old_token))
  end

  def generate_api_key(conn, params) do
    UserContext.set_api_key_on_user(Plug.Conn.get_session(conn, :user))
    id = Plug.Conn.get_session(conn, :user).id
    conn = delete_session(conn, :user)
    conn = put_session(conn, :user, UserContext.get_user!(id))
    settings(conn, params)
  end

  def api_index(conn, _) do
    if Plug.Conn.get_req_header(conn, "webshop-api-key") != [] do
      if UserContext.check_if_valid_api_key(Enum.at(Plug.Conn.get_req_header(conn, "webshop-api-key"), 0)) do
        render(conn, "index.json", users: UserContext.list_users())
      else
        render(conn, "error.json", error: "Invaild API Key given.")
      end
    else
      render(conn, "error.json", error: "No API Key given.")
    end
  end
end

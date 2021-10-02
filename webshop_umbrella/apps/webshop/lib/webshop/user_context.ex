defmodule Webshop.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Webshop.Repo
  alias Webshop.UserContext.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.userChangeset(attrs)
    |> Repo.insert()
  end

  def create_user_by_admin(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.userChangeset(attrs)
    |> Repo.update()
  end

  def update_user_by_admin(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end


  defdelegate get_acceptable_roles(), to: User

  def authenticate_user(email, unhashed_password) do
    case Repo.get_by(User, email: email) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, "Invalid password/email"}

      user ->
        if Pbkdf2.verify_pass(unhashed_password, user.password) do
          {:ok, user}
        else
          {:error, "Invalid password/email"}
        end
    end
  end

  def get_user_from_token(token) do
    Repo.get_by(User, password_reset_token: token)
  end

  def set_token_on_user(user) do
    attrs = %{
      "password_reset_token" => SecureRandom.urlsafe_base64(),
      "password_reset_sent_at" => NaiveDateTime.utc_now()
    }

    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end

  def set_api_key_on_user(user) do
    attrs = %{
      "api_key" => SecureRandom.urlsafe_base64()
    }

    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end

  def check_if_valid_api_key(api_key) do
    Repo.get_by(User, api_key: api_key) != nil
  end

  def clear_token_on_user(user) do
    attrs = %{
      "password_reset_token" => nil,
    }

    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end
end

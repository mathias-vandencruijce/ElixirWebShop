defmodule Webshop.UserContextTest do
  use Webshop.DataCase

  alias Webshop.UserContext

  describe "users" do
    alias Webshop.UserContext.User

    @valid_attrs %{city: "some city", country: "some country", email: "some email", first_name: "some first_name", house_number: 42, last_name: "some last_name", password: "some password", role: "some role", street: "some street", zip_code: 42}
    @update_attrs %{city: "some updated city", country: "some updated country", email: "some updated email", first_name: "some updated first_name", house_number: 43, last_name: "some updated last_name", password: "some updated password", role: "some updated role", street: "some updated street", zip_code: 43}
    @invalid_attrs %{city: nil, country: nil, email: nil, first_name: nil, house_number: nil, last_name: nil, password: nil, role: nil, street: nil, zip_code: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserContext.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserContext.create_user(@valid_attrs)
      assert user.city == "some city"
      assert user.country == "some country"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.house_number == 42
      assert user.last_name == "some last_name"
      assert user.password == "some password"
      assert user.role == "some role"
      assert user.street == "some street"
      assert user.zip_code == 42
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserContext.update_user(user, @update_attrs)
      assert user.city == "some updated city"
      assert user.country == "some updated country"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.house_number == 43
      assert user.last_name == "some updated last_name"
      assert user.password == "some updated password"
      assert user.role == "some updated role"
      assert user.street == "some updated street"
      assert user.zip_code == 43
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end

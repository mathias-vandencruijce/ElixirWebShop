# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Webshop.Repo.insert!(%Webshop.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, _cs} =
  Webshop.UserContext.create_user_by_admin(%{
    "first_name" => "Thor",
    "last_name" => "Odinson",
    "email" => "user@user.be",
    "role" => "User",
    "password" => "t",
    "country" => "Asgard",
    "city" => "Tonsberg",
    "zip_code" => 3110,
    "street" => "Rainbow Bridge St.",
    "house_number" => 7
  })

{:ok, _cs} =
  Webshop.UserContext.create_user_by_admin(%{
    "first_name" => "Nick",
    "last_name" => "Fury",
    "email" => "nick.fury@shield.com",
    "role" => "Manager",
    "password" => "t",
    "country" => "Classified",
    "city" => "Classified",
    "zip_code" => 777,
    "street" => "Classified",
    "house_number" => 777
  })

{:ok, _cs} =
  Webshop.UserContext.create_user_by_admin(%{
    "first_name" => "Ad",
    "last_name" => "Ministrator",
    "email" => "admin@admin.be",
    "role" => "Admin",
    "password" => "t",
    "country" => "België",
    "city" => "Tervuren",
    "zip_code" => 3080,
    "street" => "Brusselsesteenweg",
    "house_number" => 2
  })

  {:ok, _cs} =
  Webshop.ProductContext.create_product(%{
    "description" => "een product",
    "color" => "blauw",
    "price" => 15,
    "size" => 15,
    "stock" => 15,
    "title" => "product1"
  })

  {:ok, _cs} =
  Webshop.ProductContext.create_product(%{
    "description" => "een product",
    "color" => "blauw",
    "price" => 15,
    "size" => 15,
    "stock" => 15,
    "title" => "product2"
  })
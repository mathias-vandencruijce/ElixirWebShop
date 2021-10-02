defmodule Webshop.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false, size: 50
      add :last_name, :string, null: false, size: 50
      add :role, :string, null: false, default: "User"
      add :email, :string, null: false
      add :password, :string, null: false
      add :country, :string, null: false
      add :city, :string, null: false
      add :zip_code, :integer, null: false
      add :street, :string, null: false
      add :house_number, :integer, null: false

      timestamps()
    end
    create constraint(:users, :zip_code_must_be_positive, check: "zip_code > 0")
    create constraint(:users, :house_number_must_be_positive, check: "house_number > 0")
  end
end

defmodule Webshop.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :description, :string
      add :stock, :integer
      add :size, :float
      add :color, :string
      add :price, :float

      timestamps()
    end

  end
end

defmodule Webshop.Repo.Migrations.AddAddress do
  use Ecto.Migration

  def change do
    alter table(:order_histories) do
      add :postcode, :integer, null: false
      add :straatnaam, :string, null: false
      add :huisnummer, :integer, null: false
      add :busnummer, :integer, null: true
    end
  end
end

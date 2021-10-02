defmodule Webshop.Repo.Migrations.AddRetour do
  use Ecto.Migration

  def change do
    alter table(:order_histories) do
      add :retour, :boolean, null: false, default: false
    end
  end
end

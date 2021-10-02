defmodule Webshop.Repo.Migrations.AddAPIKey do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :api_key, :string, null: true
    end
  end
end

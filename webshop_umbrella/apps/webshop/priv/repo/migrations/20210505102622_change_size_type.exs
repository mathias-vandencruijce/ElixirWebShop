defmodule Webshop.Repo.Migrations.ChangeSizeType do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :size, :integer, null: false
    end
  end
end

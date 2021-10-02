defmodule Webshop.Repo.Migrations.AddEmailVerificationVariables do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_reset_token, :string, null: true
      add :password_reset_sent_at, :naive_datetime, null: true
    end
  end
end

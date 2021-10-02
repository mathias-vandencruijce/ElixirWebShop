defmodule Webshop.Repo do
  use Ecto.Repo,
    otp_app: :webshop,
    adapter: Ecto.Adapters.Postgres
end

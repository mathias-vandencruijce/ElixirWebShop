defmodule Webshop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Webshop.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Webshop.PubSub}
      # Start a worker by calling: Webshop.Worker.start_link(arg)
      # {Webshop.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Webshop.Supervisor)
  end
end

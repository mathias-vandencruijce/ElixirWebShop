# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :webshop,
  ecto_repos: [Webshop.Repo]

config :webshop_web,
  ecto_repos: [Webshop.Repo],
  generators: [context_app: :webshop]

# Configures the endpoint
config :webshop_web, WebshopWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7y/hzKsfN56w4VUfynaMldu6kz0FtBwPOvq9YxCL0l73fg7UfobcwzMh/3WJRbbC",
  render_errors: [view: WebshopWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Webshop.PubSub,
  live_view: [signing_salt: "kJDN+Kdb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :webshop_web, WebshopWeb.Guardian,
  issuer: "webshop_web",
  secret_key: "96oyQi0uvCc71NUNEUPW6pthTwyTr4CR7jqn4LDVms9BGQjj/c4ae5TojdjIp5Jo"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

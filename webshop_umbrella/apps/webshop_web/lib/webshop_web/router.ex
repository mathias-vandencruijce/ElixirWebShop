defmodule WebshopWeb.Router do
  use WebshopWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WebshopWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :allowed_for_users do
    plug WebshopWeb.Plugs.AuthorizationPlug, ["Admin", "Manager", "User"]
  end

  pipeline :allowed_for_managers do
    plug WebshopWeb.Plugs.AuthorizationPlug, ["Admin", "Manager"]
  end

  pipeline :allowed_for_admins do
    plug WebshopWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", WebshopWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    get "/login", SessionController, :index
    post "/login", SessionController, :login

    get "/register", UserController, :register
    post "/signUp", UserController, :signUp

    get "/verify", UserController, :verify
    get "/regenerateToken", UserController, :regenerate_token
    get "/resendEmail", UserController, :resend_email
    get "/shop", ProductController, :shop
    get "/product/:id", ProductController, :show
    post "/search", ProductController, :search
  end

  scope "/", WebshopWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]

    get "/logout", SessionController, :logout

    get "/settings", UserController, :settings
    put "/saveSettings", UserController, :saveSettings

    resources "/shoppingCart", ShoppingCartController
    get "/orderConfirmation", OrderHistoryController, :orderConfirmation
    post "/order", OrderHistoryController, :order
    get "/address", OrderHistoryController, :address
    get "/orders", OrderHistoryController, :orders
    get "/retour/:id", OrderHistoryController, :retour
    get "/orderConfirmation/:id", OrderHistoryController, :orderConfirmation
    get "/order/:id", OrderHistoryController, :orderOverview
  end

  scope "/", WebshopWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_managers]

  end

  scope "/admin", WebshopWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    get "/manualVerify", UserController, :manual_verify
    get "/generate_api_key", UserController, :generate_api_key
    resources "/users", UserController

    post "/importBulk", ProductController, :bulk_import
    get "/import", ProductController, :import
    resources "/products", ProductController
    get "/orderHistory", OrderHistoryController, :index
    get "/orderOverviewForUserAndOrderId", OrderHistoryController, :orderOverviewForUserAndOrderId
  end

  scope "/api", WebshopWeb do
    pipe_through :api

    get "/products", ProductController, :api_index
    get "/product/:id", ProductController, :api_show
    get "/users", UserController, :api_index
    get "/orderHistory/:id", OrderHistoryController, :api_show_user
  end

  # Other scopes may use custom stacks.
  # scope "/api", WebshopWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser
  #     live_dashboard "/dashboard", metrics: WebshopWeb.Telemetry
  #   end
  # end

  pipeline :auth do
    plug WebshopWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # To test email in browser (LocalAdapter)
  if Mix.env == :dev do
    forward "/sent_mails", Bamboo.SentEmailViewerPlug
  end
end

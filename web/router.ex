defmodule Jumubase.Router do
  use Jumubase.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: Jumubase.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes
  scope "/", Jumubase do
    pipe_through :browser

    get "/", PageController, :home
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Routes that require authentication
  scope "/internal", Jumubase.Internal, as: :internal do
    pipe_through [:browser, :browser_auth]

    resources "/hosts", HostController, only: [:index, :new, :create]
    resources "/users", UserController, only: [:index, :new, :create]
  end
end

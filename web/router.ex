defmodule Jumubase.Router do
  use Jumubase.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Jumubase do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :home
    resources "/hosts", HostController, only: [:index, :new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Jumubase do
  #   pipe_through :api
  # end
end

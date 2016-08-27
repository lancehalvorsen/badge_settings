defmodule BadgeSettings.Router do
  use BadgeSettings.Web, :router

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

  scope "/", BadgeSettings do
    pipe_through :browser # Use the default browser stack

    get "/", SessionController, :new

    resources "/session", SessionController, only: [:index, :new, :create, :delete]

    resources "/settings", SettingController, only: [:index, :show, :new, :create]
  end
end

defmodule BingoWeb.Router do
  use BingoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BingoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BingoWeb do
    pipe_through :browser

    get "/", PageController, :bingo_card
  end

  # Other scopes may use custom stacks.
  # scope "/api", BingoWeb do
  #   pipe_through :api
  # end
end

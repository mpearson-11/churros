defmodule Churros.Router do
  use Churros.Web, :router

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

  scope "/team", Churros do
    pipe_through :browser # Use the default browser stack
    get "/board", TeamController, :index
  end
  scope "/org", Churros do
    pipe_through :browser # Use the default browser stack
    get "/team/:id", OrgController, :org_team
    get "/teams/:name", OrgController, :org_teams
  end

  # Other scopes may use custom stacks.
  # scope "/api", Churros do
  #   pipe_through :api
  # end
end

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

  scope "/", Churros do
    pipe_through :browser # Use the default browser stack

    get "/board", PageController, :scrum_board
  end

  scope "/org", Churros do
    pipe_through :browser # Use the default browser stack

    get "/repos/:name", UserController, :org_repos
    get "/:name", UserController, :org
    get "/members/:name", UserController, :org_members
    get "/members/team/:id", UserController, :org_team_members
    get "/team/:id", UserController, :org_team
    get "/teams/:name", UserController, :org_teams
  end

  scope "/github", Churros do
    pipe_through :browser # Use the default browser stack

    get "/issues/:owner/:name", UserController, :issues
    get "/repo/:owner/:name", UserController, :repo
    # get "/private/:user/:password", UserController, :user
    get "/user/:name", UserController, :user
  end

  # Other scopes may use custom stacks.
  # scope "/api", Churros do
  #   pipe_through :api
  # end
end

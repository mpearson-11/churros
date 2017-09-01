defmodule Churros.Router do
  use Churros.Web, :router

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/team", Churros do
    pipe_through :browser # Use the default browser stack
    get "/board", TeamController, :index
    get "/issue-events/:id", TeamController, :issue_events
  end

  scope "/org", Churros do
    pipe_through :browser # Use the default browser stack
    get "/team/:id", OrgController, :org_team
    get "/teams/:name", OrgController, :org_teams
  end

  scope "/graphql", Churros do
    pipe_through :browser # Use the default browser stack
    get "/projects", GithubController, :graphql_projects
    get "/project/:number", GithubController, :graphql_project
    get "/test-projects", GithubController, :graphql_projects_test
  end

  scope "/watch-repo", Churros do
    pipe_through :browser # Use the default browser stack
    get "/:repo/:number", GithubController, :graphql_watch_repo
  end
end

defmodule Churros.GithubController do
  use Churros.Web, :controller
  alias Churros.Github.UtilController, as: UtilController
  alias Churros.Github.TestController, as: TestController
  require Logger

  #------------------------------------------------------------------------
  ## Broadcast to Lobby token, query and type
  defp graphql_call(type, query) do
    Churros.Endpoint.broadcast!("github:lobby", "message", %{body: %{
      token: Application.get_env(:churros, :access_token),
      query: query,
      type: type
    }})
  end

  ## Broadcast to Lobby token, query, type, number and team_name
  defp graphql_call(team_name, number, type, query) do
    Churros.Endpoint.broadcast!("github:lobby", "message", %{body: %{
      token: Application.get_env(:churros, :access_token),
      query: query,
      type: type,
      number: number,
      team_name: team_name
    }})
  end

  #------------------------------------------------------------------------
  ### Task Functions
  def organisation_teams do
    org = Application.get_env(:churros, :organisation)
    "teams" |> graphql_call(UtilController.organisation_teams(org))
  end

  def organisation_issues do
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    "issues" |> graphql_call(UtilController.organisation_issues(org, team_name))
  end

  def organisation_members do
    org = Application.get_env(:churros, :organisation)
    "members" |> graphql_call(UtilController.organisation_members(org))
  end

  def repository_projects do
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    "projects" |> graphql_call(UtilController.projects(org, team_name))
  end

  def repository_project(number) do
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    graphql_call(team_name, number, "project", UtilController.project(org, team_name, number))
  end
  
  def watched_project(team_name, number) do
    org = Application.get_env(:churros, :organisation)
    graphql_call(team_name, number, "watch-repo", UtilController.watched_project(org, team_name, number))
  end
  #------------------------------------------------------------------------

  ### Renderer's
  def graphql_projects_test(conn, _params) do
    projects = TestController.load_projects_test()
    render conn, Churros.GithubView, "projects.html", projects: projects
  end

  def graphql_projects(conn, _params) do
    render conn, Churros.LayoutView, "graphql_projects.html"
  end

  def graphql_project(conn, %{"number" => number}) do
    team_name = Application.get_env(:churros, :team_name)
    render conn, Churros.LayoutView, "graphql_project.html", id: "project-#{team_name}-#{number}", project: number, team: team_name
  end

  def graphql_watch_repo(conn, %{"repo" => repo, "number" => number }) do
    render conn, 
      Churros.LayoutView,
      "graphql_watched_repo.html",
      id: "watch-repo-#{repo}-#{number}",
      repo: repo,
      number: number
  end
  #------------------------------------------------------------------------
end
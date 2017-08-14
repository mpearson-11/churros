defmodule Churros.GithubController do
  use Churros.Web, :controller
  alias Churros.Github.UtilController, as: UtilController
  require Logger

  def organisation_teams do
    org = Application.get_env(:churros, :organisation)
    "teams" |> graphql_call(UtilController.organisation_teams(org))
    true
  end

  def organisation_issues do
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    "issues" |> graphql_call(UtilController.organisation_issues(org, team_name))
    true
  end

  def organisation_issues_html(repo, text) do
    org = Application.get_env(:churros, :organisation)
    "issues" |> graphql_call(UtilController.organisation_issues_timeline(org, repo))
    true
  end

  def organisation_members do
    org = Application.get_env(:churros, :organisation)
    "members" |> graphql_call( UtilController.organisation_members(org))
    true
  end

  def repository_projects do
    Logger.info "Loading Repository Projects ===>"

    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    "projects" |> graphql_call(UtilController.projects(org, team_name))
    true
  end

  def repository_project(number) do
    Logger.info "Loading Repository Project ===>"

    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    "project" |> graphql_call(UtilController.project(org, team_name, number))
    true
  end

  def graphql_issues_html(conn, _params) do
    render conn, Churros.LayoutView, "graphql_issues_html.html"
  end

  def graphql_projects(conn, _params) do
    render conn, Churros.LayoutView, "graphql_projects.html"
  end

  def graphql_project(conn, %{"number" => number}) do
    render conn, Churros.LayoutView, "graphql_project.html", number: number
  end

  defp graphql_call(type, query) do
    Churros.Endpoint.broadcast!("github:lobby", "message", %{body: %{
      token: Application.get_env(:churros, :access_token),
      query: query,
      type: type
    }})
  end
end
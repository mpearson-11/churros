defmodule Churros.GithubController do
  use Churros.Web, :controller
  alias Churros.Github.UtilController, as: UtilController
  alias Churros.Github.MainController, as: MainController

  def organisation_teams() do
    org = Application.get_env(:churros, :organisation)
    graphql_call(UtilController.organisation_teams(org), "teams")
  end

  def organisation_issues() do
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    graphql_call(UtilController.organisation_issues(org, team_name), "issues")
  end

  def organisation_members() do
    org = Application.get_env(:churros, :organisation)
    graphql_call(UtilController.organisation_members(org), "members")
  end

  def repository_projects() do
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    graphql_call(UtilController.projects(org, team_name), "projects")
  end

  def grapql_test(conn, %{"query" => query}) do
    render conn, Churros.LayoutView, "messages.html"
  end

  defp graphql_call(query, type) do
    Churros.Endpoint.broadcast("github:lobby", "message", %{body: %{
      token: Application.get_env(:churros, :access_token),
      query: query,
      type: type
    }})
  end
end
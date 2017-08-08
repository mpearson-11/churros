defmodule Churros.GithubController do
  use Churros.Web, :controller
  alias Churros.Github.UtilController, as: UtilController
  alias Churros.Github.MainController, as: MainController

  def organisation_teams() do
    org = Application.get_env(:churros, :organisation)
    "teams" |> graphql_call(UtilController.organisation_teams(org))
    true
  end

  def organisation_issues() do
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    "issues" |> graphql_call(UtilController.organisation_issues(org, team_name))
    true
  end

  def organisation_members() do
    org = Application.get_env(:churros, :organisation)
    "members" |> graphql_call( UtilController.organisation_members(org))
    true
  end

  def repository_projects() do
    IO.inspect("=> Loading repository projects")
    org = Application.get_env(:churros, :organisation)
    team_name = Application.get_env(:churros, :team_name)
    "projects" |> graphql_call(UtilController.projects(org, team_name))
    true
  end

  def graphql_space(conn, _params) do
    render conn, Churros.LayoutView, "messages.html"
  end

  defp graphql_call(type, query) do
    Churros.Endpoint.broadcast("github:lobby", "message", %{body: %{
      token: Application.get_env(:churros, :access_token),
      query: query,
      type: type
    }})
  end
end
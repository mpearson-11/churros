defmodule Churros.OrgController do
  use Churros.Web, :controller
  alias Churros.Github.MainController, as: Github

  @client(Tentacat.Client.new(%{access_token: Application.get_env(:churros, :access_token)}))

  def org_teams(conn, %{"name" => name}) do
    org_teams = Github.organisation_teams(name, @client)
    render conn, "org_teams.html", teams: org_teams
  end
  
  def org_team(conn, %{"id" => id}) do
    org_team = Github.organisation_team(id, @client)
    org_team_members = Github.organisation_team_members(id, @client)
    IO.inspect(org_team_members)
    render conn, "org_team_info.html", team: org_team, members: org_team_members
  end
end

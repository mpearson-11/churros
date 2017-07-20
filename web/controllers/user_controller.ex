defmodule Churros.UserController do
  use Churros.Web, :controller
  alias Churros.GithubController, as: GitHub

  @client(Tentacat.Client.new(%{access_token: Application.get_env(:churros, :access_token)}))

  def org_repos(conn, %{"name" => name}) do
    found = GitHub.organisation_repos(name, @client)
    json conn, found
  end

  def org_team(conn, %{"id" => id }) do
    team = GitHub.organisation_team(id, @client)
    members = GitHub.organisation_team_members(id, @client)
    IO.inspect(team)
    render(conn, "_team_info.html", team: team, members: members)
  end
  
  def org_teams(conn, %{"name" => name }) do
    found = GitHub.organisation_teams(name, @client)
    IO.inspect(found)
    render(conn, "teams.html", teams: found)
  end

  def org_members(conn, %{"name" => name }) do
    found = GitHub.organisation_members(name, @client)
    IO.inspect(found)
    render(conn, "members.html", users: found)
  end

  def org_team_members(conn, %{"id" => id }) do
    found = GitHub.organisation_team_members(id, @client)
    IO.inspect(found)
    render(conn, "members.html", users: found)
  end

  def org(conn, %{"name" => name }) do
    found = GitHub.organisation(name, @client)
    json conn, found
  end

  def issues(conn, %{"owner" => owner, "name" => name }) do
    found = GitHub.issues(owner, name, @client)
    render(conn, "user_issues.html", issues: found, conn: @conn)
  end

  def repo(conn, %{"owner" => owner, "name" => name }) do
    found = GitHub.repo(owner, name, @client)
    render(conn, "user_repo.html", repo: found, owner: owner)
  end
end


defmodule Churros.Github.MainController do
  use Churros.Web, :controller
  def user_events(name, org, client) do
    Tentacat.Users.Events.list_user_org(name, org, client)
  end
  def user_events(name, client) do
    Tentacat.Users.Events.list(name, client)
  end
  def organisation_teams(name, client) do
    Tentacat.Organizations.Teams.list(name, client)
  end
  def organisation_team(id, client) do
    Tentacat.Organizations.Teams.find(id, client)
  end
  def organisation_members(name, client) do
    Tentacat.Organizations.Members.list(name, client)
  end
  def organisation_team_members(team_id, client) do
    Tentacat.Teams.Members.list(team_id, client)
  end
  def organisation_repos(name, client) do
    Tentacat.Repositories.list_orgs(name, client)
  end
  def organisation(name, client) do
    Tentacat.Organizations.find(name, client)
  end
  def issues(owner, name, client) do
    Tentacat.Issues.list(owner, name, client)
  end
  def issues_open(owner, name, client) do
    issues = Tentacat.Issues.filter(owner, name, %{"status" => "open", "filter" => "assigned" }, client)
    case {issues} do
      {:error, %HTTPoison.Error{id: nil, reason: :timeout}} -> nil
      _ -> issues
    end
  end
  def repo(owner, name, client) do
    Tentacat.Repositories.repo_get(owner, name, client)
  end
end
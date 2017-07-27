defmodule Churros.TeamController do
  use Churros.Web, :controller
  alias Churros.GithubController, as: GitHub

  @client(Tentacat.Client.new(%{access_token: Application.get_env(:churros, :access_token)}))
  
  def user(conn, %{"name" => name}) do
    found = Tentacat.Users.find(name, @client)
    render(conn, "user.html", user: found)
  end

  defp team(:name) do
    Application.get_env(:churros, :team_name)
  end
  defp team(:id) do
    Application.get_env(:churros, :team_id)
  end
  defp team(:org) do
    Application.get_env(:churros, :organisation)
  end
  
  def filter_issues(issues) do
    Enum.filter(issues, fn(i) -> 
      i["assignee"] !== nil && i["assignees"] !== []
    end)
  end

  defp issue_events(id) do
    name = team(:name)
    organisation = team(:org)
    GitHub.issue_events(organisation, name, id, @client)
  end

  def index(conn, _params) do
    id = team(:id)
    name = team(:name)
    organisation = team(:org)
  
    _team = GitHub.organisation_team(id, @client)
    
    _issues = filter_issues(GitHub.issues_open(organisation, name, @client))

    render conn, "index.html", team: _team, issues: _issues
  end
end


defmodule Churros.PageController do
  use Churros.Web, :controller
  alias Churros.GithubController, as: GitHub

  @client(Tentacat.Client.new(%{access_token: Application.get_env(:churros, :access_token)}))

  def user(conn, %{"name" => name}) do
    found = Tentacat.Users.find(name, @client)
    render(conn, "user.html", user: found)
  end

  def team(:name) do
    Application.get_env(:churros, :team_name)
  end
  def team(:id) do
    Application.get_env(:churros, :team_id)
  end
  
  def filter_issues(issues) do
    Enum.filter(issues, fn(i) -> 
      i["assignee"] !== nil && i["assignees"] !== []
    end)
  end

  def scrum_board(conn, _params) do
    id = team(:id)
    name = team(:name)

    _team = GitHub.organisation_team(id, @client)
    _members = GitHub.organisation_team_members(id, @client)
    _issues = filter_issues(GitHub.issues_open("sky-uk", name, @client))
    IO.inspect(_issues)
    render conn, "scrum_board.html", team: _team, members: _members, issues: _issues
  end

  def index(conn, _params) do
    render conn, "index.html"
  end
end

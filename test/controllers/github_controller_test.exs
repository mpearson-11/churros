defmodule Churros.GithubControllerTest.Mock do
  @mock_org("TEST_ORGANISATION")
  @mock_team_name("TEST_TEAM_NAME")
  @mock_token("TEST_ACCESS_TOKEN")

  #Mock graphql http body object
  defp mock_graphql_call(query, type) do
    %{body: %{ query: query, type: type, token: @mock_token }}
  end
  defp mock_graphql_call(query, type, number, team_name) do
    %{body: %{ query: query, type: type, number: number, team_name: team_name, token: @mock_token }}
  end

  #Mock querys
  def organisation_teams_mock() do
    query = Churros.Github.UtilController.organisation_teams(@mock_org)
    query |> mock_graphql_call("teams")
  end
  def organisation_issues_mock() do
    query = Churros.Github.UtilController.organisation_issues(@mock_org, @mock_team_name)
    query |> mock_graphql_call("issues")
  end
  def organisation_members_mock() do
    query = Churros.Github.UtilController.organisation_members(@mock_org)
    query |> mock_graphql_call("members")
  end
  def repository_projects_mock() do
    query = Churros.Github.UtilController.projects(@mock_org, @mock_team_name)
    query |> mock_graphql_call("projects")
  end
  def repository_project_mock(number) do
    query = Churros.Github.UtilController.project(@mock_org, @mock_team_name, number)
    query |> mock_graphql_call("project", number, @mock_team_name)
  end
  def watched_project_mock(team_name, number) do
    query = Churros.Github.UtilController.watched_project(@mock_org, team_name, number)
    query |> mock_graphql_call("watch-repo", number, team_name)
  end
end

defmodule Churros.GithubControllerTest do
  use ExUnit.Case, async: false
  use Churros.ConnCase, async: true
  import Mock
  import Snapshot

  @mock (
    Churros.GithubControllerTest.Mock
  )

  test_with_mock "organisation_teams", Churros.Endpoint, [], [broadcast!: fn(r, m, o) -> [r, m, o] end] do
    [room, message, socket_message] = Churros.GithubController.organisation_teams
  
    assert room === "github:lobby"
    assert message === "message"
    assert socket_message === @mock.organisation_teams_mock
  end
  
  test_with_mock "organisation_issues", Churros.Endpoint, [], [broadcast!: fn(r, m, o) -> [r, m, o] end] do
    [room, message, socket_message] = Churros.GithubController.organisation_issues
  
    assert room === "github:lobby"
    assert message === "message"
    assert socket_message === @mock.organisation_issues_mock
  end

  test_with_mock "organisation_members", Churros.Endpoint, [], [broadcast!: fn(r, m, o) -> [r, m, o] end] do
    [room, message, socket_message] = Churros.GithubController.organisation_members
  
    assert room === "github:lobby"
    assert message === "message"
    assert socket_message === @mock.organisation_members_mock
  end

  test_with_mock "repository_projects", Churros.Endpoint, [], [broadcast!: fn(r, m, o) -> [r, m, o] end] do
    [room, message, socket_message] = Churros.GithubController.repository_projects
  
    assert room === "github:lobby"
    assert message === "message"
    assert socket_message === @mock.repository_projects_mock
  end

  test_with_mock "repository_project", Churros.Endpoint, [], [broadcast!: fn(r, m, o) -> [r, m, o] end] do
    project_number = 2
    [room, message, socket_message] = Churros.GithubController.repository_project(project_number)
  
    assert room === "github:lobby"
    assert message === "message"
    assert socket_message === @mock.repository_project_mock(project_number)
  end

  test_with_mock "watched_project", Churros.Endpoint, [], [broadcast!: fn(r, m, o) -> [r, m, o] end] do
    team_name = "LUCA:ELLO"
    project_number = 2
    [room, message, socket_message] = Churros.GithubController.watched_project(team_name, project_number)
  
    assert room === "github:lobby"
    assert message === "message"
    assert socket_message === @mock.watched_project_mock(team_name, project_number)
  end

  ## Partial Render Tests
  test "renders graphql_projects.html with router /graphql/test-projects", %{conn: conn} do
    conn = get conn, "/graphql/test-projects"
    snapshot(%{
      "file_name" => "graphql_projects",
      "dir1" => "graphql",
      "dir2" => "test-projects",
      "html" => html_response(conn, 200)
    })
  end
  test "renders graphql_projects.html with router /graphql/projects", %{conn: conn} do
    conn = get conn, "/graphql/projects"
    snapshot(%{
      "file_name" => "graphql_projects",
      "dir1" => "graphql",
      "dir2" => "projects",
      "html" => html_response(conn, 200)
    })
  end
  test "renders graphql_project.html with router /graphql/project/number", %{conn: conn} do
    conn = get conn, "/graphql/project/hello-world"
    snapshot(%{
      "file_name" => "graphql_project",
      "dir1" => "graphql",
      "dir2" => "project",
      "html" => html_response(conn, 200)
    })
  end
  test "renders graphql_watched_repo.html with router /watch-repo/project/number?watching=", %{conn: conn} do
    conn = get conn, "/watch-repo/test-project/1?watching=4145"
    snapshot(%{
      "file_name" => "graphql_watched_repo",
      "dir1" => "watch-repo",
      "dir2" => "test-project",
      "html" => html_response(conn, 200)
    })
  end
end
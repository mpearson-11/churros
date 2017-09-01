defmodule Churros.TeamControllerTest.Mock do
  def issues_mock() do
    [
      assignees: [
        %{"login" => "TEST_NAME", "avatarUrl" => "https://avatars0.githubusercontent.com/u/15046615?v=4&s=460" },
        %{"login" => "TEST_NAME", "avatarUrl" => "https://avatars0.githubusercontent.com/u/15046615?v=4&s=460" }
      ]
    ]
  end
end

defmodule Churros.TeamControllerTest do
  use ExUnit.Case, async: false
  use Churros.ConnCase, async: true

  import Mock
  import Snapshot

    # team_ = GitHub.organisation_team(id, @client)
    # github_issues = GitHub.issues_open(organisation, name, @client)

  test "renders index.html with router /team/board", %{conn: conn} do
    with_mocks([
      {Churros.Github.MainController, [], [organisation_team: fn(id, client) -> [] end]},
      {Churros.Github.MainController, [], [issues_open: fn(org, name, client) -> [] end]}
    ]) do
      conn = get conn, "/team/board"
      snapshot(%{
        "file_name" => "index",
        "path" => ["team", "board"],
        "html" => html_response(conn, 200)
      })
    end
  end
end
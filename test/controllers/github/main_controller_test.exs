defmodule Churros.Github.MainControllerTest do
  use ExUnit.Case, async: false
  import Mock

  test_with_mock "user_events /3", Tentacat.Users.Events, [], [list_user_org: fn(name, org, client) -> [name, org, client] end] do
    events = Churros.Github.MainController.user_events("Name", "MyOrg", "MyClient")
    assert events === ["Name", "MyOrg", "MyClient"]
  end

  test_with_mock "user_events /2", Tentacat.Users.Events, [], [list: fn(name, client) -> [name, client] end] do
    events = Churros.Github.MainController.user_events("Name", "MyClient")
    assert events === ["Name", "MyClient"]
  end

  test_with_mock "organisation_teams", Tentacat.Organizations.Teams, [], [list: fn(name, client) -> [name, client] end] do
    events = Churros.Github.MainController.organisation_teams("Name", "MyClient")
    assert events === ["Name", "MyClient"]
  end

  test_with_mock "organisation_team", Tentacat.Organizations.Teams, [], [find: fn(id, client) -> [id, client] end] do
    events = Churros.Github.MainController.organisation_team("Id", "MyClient")
    assert events === ["Id", "MyClient"]
  end

  test_with_mock "organisation_members", Tentacat.Organizations.Members, [], [list: fn(name, client) -> [name, client] end] do
    events = Churros.Github.MainController.organisation_members("Name", "MyClient")
    assert events === ["Name", "MyClient"]
  end

  test_with_mock "organisation_team_members", Tentacat.Teams.Members, [], [list: fn(team_id, client) -> [team_id, client] end] do
    events = Churros.Github.MainController.organisation_team_members("Team ID", "MyClient")
    assert events === ["Team ID", "MyClient"]
  end

  test_with_mock "organisation_repos", Tentacat.Repositories, [], [list_orgs: fn(name, client) -> [name, client] end] do
    events = Churros.Github.MainController.organisation_repos("Name", "MyClient")
    assert events === ["Name", "MyClient"]
  end

  test_with_mock "organisation", Tentacat.Organizations, [], [find: fn(name, client) -> [name, client] end] do
    events = Churros.Github.MainController.organisation("Name", "MyClient")
    assert events === ["Name", "MyClient"]
  end

  test_with_mock "issues", Tentacat.Issues, [], [list: fn(owner, name, client) -> [owner, name, client] end] do
    events = Churros.Github.MainController.issues("Owner", "Name", "MyClient")
    assert events === ["Owner", "Name", "MyClient"]
  end

  test_with_mock "issues_open (error)", Tentacat.Issues, [], [filter: fn(owner, name, object, client) -> {:error, %HTTPoison.Error{id: "123456", reason: :timeout}} end] do
    events = Churros.Github.MainController.issues_open("Owner", "Name","MyClient")
    assert events === nil
  end
  
  test_with_mock "issues_open (ok)", Tentacat.Issues, [], [filter: fn(owner, name, object, client) -> [] end] do
    events = Churros.Github.MainController.issues_open("Owner", "Name","MyClient")
    assert events === []
  end
end
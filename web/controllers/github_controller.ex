defmodule Churros.GithubController do
  use Churros.Web, :controller
  alias Churros.Github.UtilController, as: UtilController
  alias Churros.Github.MainController, as: MainController

  def organisation_teams() do
    org = Application.get_env(:churros, :organisation)
    graphql_call(UtilController.organisation_teams(org), "teams")
  end

  def organisation_members() do
    org = Application.get_env(:churros, :organisation)
    graphql_call(UtilController.organisation_members(org), "members")
  end

  def grapql_test(conn, %{"query" => query}) do
    graphql_call(" query { viewer { login } }", "teams")
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
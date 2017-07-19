defmodule Churros.UserController do
  use Churros.Web, :controller
  alias Churros.GithubController, as: GitHub

  @client(Tentacat.Client.new(%{access_token: Application.get_env(:churros, :access_token)}))

  def issues(conn, %{"owner" => owner, "name" => name }) do
    found = GitHub.issues(owner, name, @client)
    IO.inspect(found)
    render(conn, "user_issues.html", issues: found, conn: @conn)
  end

  def repo(conn, %{"owner" => owner, "name" => name }) do
    found = GitHub.repo(owner, name, @client)
    IO.inspect(found)
    render(conn, "user_repo.html", repo: found, owner: owner)
  end

  def user(conn, %{"name" => name}) do
    found = Tentacat.Users.find(name, @client)
    IO.inspect(found)
    render(conn, "user.html", user: found)
  end
end


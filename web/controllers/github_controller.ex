defmodule Churros.GithubController do
  def issues(owner, name, client) do
    Tentacat.Issues.list(owner, name, client)
  end
  def repo(owner, name, client) do
    Tentacat.Repositories.repo_get(owner, name, client)
  end
end
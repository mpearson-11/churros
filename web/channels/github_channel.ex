defmodule Churros.GithubChannel do
  use Phoenix.Channel
  
  defp process(body) do
    {:ok, params} = JSON.decode(body)
    params
  end

  @client(Tentacat.Client.new(%{access_token: Application.get_env(:churros, :access_token)}))

  #Util functions
  defp data(body) do
    body["data"]
  end
  defp organization(body) do
    body["organization"]
  end
  defp teams(body) do 
    body["teams"]
  end
  defp nodes(body) do
    body["nodes"]
  end
  defp repository_owner(body) do
    body["repositoryOwner"]
  end
  defp repository(body) do
    body["repository"]
  end
  defp projects(body) do
    body["projects"]
  end
  defp project(body) do
    body["project"]
  end
  defp issues(body) do
    body["issues"]
  end
  ##-------------------------------------------------

  defp process(body, :teams) do
    process(body)
    |> data
    |> organization
    |> teams
    |> nodes
  end

  defp process(body, :projects) do
    process(body)
    |> data
    |> repository_owner
    |> repository
    |> projects
    |> nodes
  end

  defp process(body, :project) do
    process(body)
    |> data
    |> repository_owner
    |> repository
    |> project
  end

  defp process(body, :issues) do
    process(body)
    |> data
    |> repository_owner
    |> repository
    |> issues
    |> nodes
  end

  def join("github:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("github:" <> _private_github_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
  
  def handle_in("message", %{"body" => body}, socket) do
    broadcast! socket, "message", %{body: body}
    {:noreply, socket}
  end

  def handle_out("message", payload, socket) do
    push socket, "message", payload
    {:noreply, socket}
  end

  def handle_in("refresh_issues", _params, socket) do
    broadcast! socket, "refresh_issues", %{}
    {:noreply, socket}
  end

  def handle_in("github:teams", params, socket) do
    data = process(params, :teams)
    html = Phoenix.View.render_to_string(Churros.GithubView, "teams.html", teams: data)

    broadcast!(socket, process(params)["ack"], %{ html: html })
    {:noreply, socket}
  end

  def handle_in("github:members", _, socket) do
    {:noreply, socket}
  end

  def handle_in("github:projects", params, socket) do
    data = process(params, :projects)
    html = Phoenix.View.render_to_string(Churros.GithubView, "projects.html", projects: data)

    broadcast!(socket, process(params)["ack"], %{ html: html})
    {:noreply, socket}
  end

  def handle_in("github:project", params, socket) do
    data = process(params, :project)
    html = Phoenix.View.render_to_string(Churros.GithubView, "project.html", project: data)

    broadcast!(socket, process(params)["ack"], %{ html: html})
    {:noreply, socket}
  end

  def handle_in("github:watch-repo", params, socket) do
    data = process(params, :project)
    team_id = Application.get_env(:churros, :team_id)
    IO.inspect(data)
    team = Churros.Github.MainController.organisation_team_members(team_id, @client)
    html = Phoenix.View.render_to_string(Churros.GithubView, "watched_repo.html", project: data, team: team)
    broadcast!(socket, process(params)["ack"], %{ html: html})
    {:noreply, socket}
  end

  def handle_in("github:issues", params, socket) do
    data = process(params, :issues)
    html = Phoenix.View.render_to_string(Churros.GithubView, "issues.html", issues: data)

    broadcast!(socket, process(params)["ack"], %{ html: html })
    {:noreply, socket}
  end
end
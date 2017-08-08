defmodule Churros.GithubChannel do
  use Phoenix.Channel
  
  defp process(body) do
    {:ok, params} = JSON.decode(body)
    params
  end

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

  defp process(body, :issues) do
    process(body)
    |> data
    |> repository_owner
    |> repository
    |> issues
    |> nodes
  end

  def process_map(type) do
    %{"issues": :issues}
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

  def handle_in("github:teams", params, socket) do
    data = process(params, :teams)
    html = Phoenix.View.render_to_string(Churros.GithubView, "teams.html", teams: data)

    broadcast!(socket, process(params)["ack"], %{ html: html })
    {:noreply, socket}
  end

  def handle_in("github:members", params, socket) do
    {:noreply, socket}
  end
  
  def handle_in("github:projects", params, socket) do
    data = process(params, :projects)
    html = Phoenix.View.render_to_string(Churros.GithubView, "projects.html", projects: data)

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
defmodule Churros.GithubChannel do
  use Phoenix.Channel

  defp process(body) do
    {:ok, params} = JSON.decode(body)
    params
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
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_in("github:members", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
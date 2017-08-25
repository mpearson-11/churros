defmodule Churros.UserSocket do
  use Phoenix.Socket

  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  # channel "rooms:*", Churros.RoomChannel
  channel "github:*", Churros.GithubChannel

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  def connect(params, socket) do
    {:ok, assign(socket, :user_id, params["user_id"])}
  end
  def connect(%{"token" => token}, socket) do
    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user, user_id)}
      {:error, _reason} ->
        :error
    end
  end
end

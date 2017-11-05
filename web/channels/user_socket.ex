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
end

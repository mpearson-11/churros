defmodule Churros.PageController do
  use Churros.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

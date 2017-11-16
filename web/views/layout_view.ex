defmodule Churros.LayoutView do
  use Churros.Web, :view

  def css(image_path) do
    ["background-size: 100%","background-image: url(#{image_path}) !important"]
    |> Enum.join(";")
  end

  def html_background(conn) do
    image_path =  static_path(conn, "/images/christmas.jpeg")
    css(image_path)
  end
end

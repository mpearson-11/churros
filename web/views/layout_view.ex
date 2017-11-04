defmodule Churros.LayoutView do
  use Churros.Web, :view

  def html_background(conn) do
    image_path =  static_path(conn, "/images/image-2.jpg")
    "background-size: 100%; background-repeat: no-repeat; background-image: url(#{image_path}) !important;"
  end
end

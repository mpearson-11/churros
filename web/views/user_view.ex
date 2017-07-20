defmodule Churros.UserView do
  use Churros.Web, :view

  def convert(str) when is_atom(str) do
    Atom.to_string(str)
  end
  def convert(str) when is_bitstring(str) do
    str
  end
  def convert(str) when is_integer(str) do
    Integer.to_string(str)
  end
  def convert(str) when is_list(str) do
    nil
  end
end

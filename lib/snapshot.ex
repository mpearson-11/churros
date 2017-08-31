defmodule Snapshot do
  def path do
    "./test/snapshots/routes"
  end
  def path_creator(directories) do
    "#{path}/#{Enum.join(directories, "/")}"
  end
  def snapshot(%{
    "file_name" => file_name,
    "dir1" => dir1,
    "html" => html
  }) do
    directory = path_creator([dir1])
    File.mkdir(directory)
    File.write("#{directory}/#{file_name}.html", html, [:raw])
  end

  def snapshot(%{
    "file_name" => file_name,
    "dir1" => dir1,
    "dir2" => dir2,
    "html" => html
  }) do
    directory = path_creator([dir1, dir2])
    File.mkdir(directory)
    File.write("#{directory}/#{file_name}.html", html, [:raw])
  end
  
  def snapshot(%{
    "file_name" => file_name,
    "dir1" => dir1,
    "dir2" => dir2,
    "dir3" => dir3,
    "html" => html
  }) do
    directory = path_creator([dir1, dir2, dir3])
    File.mkdir(directory)
    File.write("#{directory}/#{file_name}.html", html, [:raw])
  end
end
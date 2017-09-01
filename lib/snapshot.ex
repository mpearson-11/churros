defmodule Snapshot do
  def path_creator(directories) do
    Path.join(["test","snapshots", "routes", Path.join(directories)])
  end
  def write_file(directory, file_name, html) do
    File.mkdir_p!(directory)
    File.write!(Path.join(directory, "#{file_name}.html"), html, [:raw])
  end
  def snapshot(%{"file_name" => file_name, "path" => path, "html" => html }) do
    write_file(path_creator(path), file_name, html)
  end
end
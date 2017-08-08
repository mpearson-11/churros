defmodule Churros.GithubView do
  use Churros.Web, :view

  def content(data) do
    data["content"]
  end
  def assignees(data) do
    data["assignees"]
  end
  def nodes(data) do
    data["nodes"]
  end
  def cards(data) do
    data["cards"]
  end

  def filter_card(card) do
    if card != nil && Map.has_key?(card, "content") do
      card |> content |> assignees |> nodes || []
    else
      []
    end
  end

  def filter_cards(nodes) do
    Enum.reduce(nodes, [], fn(card, acc) ->
      case card do
        {:ok} -> []
        _ -> filter_card(card) ++ acc
      end
    end)
  end

  def filter_column(column, :correct) do
    if column["cards"] != nil && (column |> cards |> nodes != nil) do
      column |> cards |> nodes |> filter_cards
    else
      []
    end
  end

  def filter_assignees(project) do
    columns = project["columns"]["nodes"]
    assignees = Enum.reduce(columns, [], fn(column, acc) ->
      case column do
        {:ok} -> []
        _ -> filter_column(column, :correct) ++ acc
      end
    end)
    assignees |> Enum.uniq
  end

  def get_projects() do
    # Task.start(fn ->
    #   Process.sleep(1000)
    #   Churros.GithubController.repository_projects()
    # end)
    nil
  end
end

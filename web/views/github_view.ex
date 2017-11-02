defmodule Churros.GithubView do
  use Churros.Web, :view
  def has_note?(data) do
    data["note"] || nil
  end
  def number(data) do
    data["number"]
  end
  def title(data) do
    data["title"]
  end
  def content(data) do
    data["content"]
  end
  def note(data) do
    data["note"]
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
  def columns(data) do
    data["columns"]
  end
  def nil_condition(data) do
    data || []
  end
  def assignee0(data) do
    asignee_nodes = filter_card(data)

    if length(asignee_nodes) >= 0 do
      Enum.at(asignee_nodes, 0)["login"]
    else
      ""
    end
  end

  def filter_card(card) do
    if card != nil && Map.has_key?(card, "content") do
      card
      |> content
      |> assignees
      |> nodes
      |> nil_condition
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

  def filter_column(column) do
    column_nodes = column |> cards |> nodes
    if column["cards"] != nil && column_nodes != nil do
      column
      |> cards
      |> nodes
      |> filter_cards
    else
      []
    end
  end

  def filter_columns(columns_nodes) do
    Enum.reduce(columns_nodes, [], fn(column, acc) ->
      case column do
        {:ok} -> []
        _ -> filter_column(column) ++ acc
      end
    end)
  end

  def has_team_member(card, team) do
    assignees = filter_card(card)
    has_member = length(Enum.filter(team, fn(member) -> 
      Enum.find(assignees, fn(assignee) -> 
        member["login"] == assignee["login"]
      end) || nil
    end)) > 0
    has_member && "true" || "false"
  end

  def filter_assignees(project) do
    # ------------------------------------------------------ #
    # Cleaned up                                             #
    # ------------------------------------------------------ #
    # ^ Enum.uniq(filter_columns(nodes(columns(project))))
    # ------------------------------------------------------ #
    project
    |> columns
    |> nodes
    |> filter_columns
    |> Enum.uniq
  end
end

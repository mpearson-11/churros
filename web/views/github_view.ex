defmodule Churros.GithubView do
  use Churros.Web, :view

  defp mod(x,y) when x > 0, do: rem(x, y);
  defp mod(x,y) when x < 0, do: rem(x, y) + y;
  defp mod(0,_y), do: 0

  def which_number(number) do
    if number == 1 do
      "1st"
    else
      case mod(number, 10) do
        0 -> "#{number}th"
        1 -> "#{number}st"
        2 -> "#{number}nd"
        3 -> "#{number}rd"
        _ -> "#{number}th"
      end
    end
  end

  defp card_number(number) do
    "card-#{number}"
  end

  def card_id(card) do
    card
    |> content
    |> number
    |> card_number
  end

  def cards_with_index(column) do
    column
    |> cards
    |> nodes
    |> Enum.with_index
  end

  def cards_name(column) do
    column
    |> cards
    |> name
  end

  def name(data) do
    data["name"] || nil
  end

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

  defp socket_boolean(data) do
    len = length(data) > 0
    len && true || false
  end

  def find_members_in(card, team) do
    assignees = filter_card(card)

    Enum.filter(team, fn(member) -> 
      Enum.find(assignees, fn(assignee) -> 
        member["login"] == assignee["login"]
      end) || nil
    end)
  end

  def has_team_member(card, team) do
    card 
    |> find_members_in(team)
    |> socket_boolean
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

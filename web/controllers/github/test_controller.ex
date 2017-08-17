defmodule Churros.Github.TestController do
  use Churros.Web, :controller

  def load_projects_test() do
    [ 
      %{ 
        "name" => "Test Project",
        "number" => 1,
        "columns" => create_columns
      },
      %{
        "name" => "Test Project",
        "number" => 2,
        "columns" => create_columns
      }
    ]
  end

  def create_columns do
    %{
      "nodes" => [
        create_column(1, "Backlog"),
        create_column(2, "In Progress"),
        create_column(3, "Development"),
        create_column(4, "Code Review"),
        create_column(5, "QA"),
      ]
    }
  end
  def create_column(n, name) do
    %{ "number" => n, "name" => name, "cards" => create_cards() }
  end
  def create_cards do
    %{
      "nodes" => [
        create_card(1, "card-1"),
        create_card(2, "card-2"),
        create_card(3, "card-3"),
        create_card(4, "card-4"),
        create_card(5, "card-5"),
        create_card(6, "card-6"),
        create_card(7, "card-7"),
        create_card(8, "card-8"),
        create_card(9, "card-9"),
        create_card(10, "card-10")
      ]
    }
  end
  def create_card(n, name) do
    %{ "content" => card_content(n, name) }
  end
  def card_content(number, title) do
    %{
      "title" => title,
      "number" => number,
      "mergedAt" => "39821038921",
      "closed" => "false",
      "merged" => "false",
      "labels" => labels(),
      "assignees" => create_assignees()
    }
  end
  def create_assignees do
    %{
      "nodes" => [ 
        create_assignee("Max 1"),
        create_assignee("Max 2"),
        create_assignee("Max 3"),
        create_assignee("Max 4")
      ]
    }
  end
  def create_assignee(name) do
    %{"login" => name, "avatarUrl" => "https://avatars0.githubusercontent.com/u/15046615?v=4&s=460" }
  end
  def labels do
    %{
      "nodes" => [
        %{ "name" => "Label 1" },
        %{ "name" => "Label 2" }
      ]
    }
  end
end
defmodule Churros.GithubBoardTasks do
  @moduledoc """
  GithubTask calls repository_projects function for GithubController, every 3 minutes
  and the console will log out how long before the function runs again.
  """

  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, 0)
  end
  defp enabled_boards do
    ["27", "26", "25", "24", "22", "14", "10"]
  end

  def init(_) do
    # Task starter
    Process.send_after(self(), :enabled_projects_task, start_work_time())
    {:ok, work_time()}
  end

  def start_work_time do
    1 |> TimeUtility.minutes
  end

  def work_time do
    20 |> TimeUtility.seconds
  end

  defp work_tasks do
    Enum.each(enabled_boards, fn(board) ->
      Churros.GithubController.repository_project(board)
    end)
  end

  def handle_info(:enabled_projects_task, state) do
    watched_boards = enabled_boards()
    Logger.info "\nGithub Task, load projects: #{Enum.join(watched_boards)}"

    work_tasks() # Private function work task
    Process.send_after(self(), :enabled_projects_task, work_time())
    {:noreply, state}
  end
end